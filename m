Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E0D65B8B8
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 02:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjACBNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 20:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbjACBNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 20:13:35 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D458F108;
        Mon,  2 Jan 2023 17:13:34 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id r11so26036062oie.13;
        Mon, 02 Jan 2023 17:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yUSv/leba9Q8axsenHUf6zXYFVRcTyGLlPdp1AvGirA=;
        b=ZPtv1A+0c/LYbTYf8+62Xm7V3htqTzY8fpIRU9yDMHw/DlKurcu0aikSSnSJwPn2+C
         wxDeGoUstJMz4i2mPn8CFE9FXh1rTcaQ4LI3mT+Qog828iFZ61mkgJRolL67g1qdg17z
         dE7tOXdm4IbUMrw3OqzPSPQ7fB5Q4w3O4mNR/UN5E6qaVNn+hEA1Rp0XB2GNAjtGDsUq
         ubhDnr1wv0fWU8aMylRO0AdEpNB/CbmJ5eRjhD8Yhpl8NwJmDQ4jfGbt+S+ACQ+HHd+h
         TqTmcLIzcU58XVlH4t9CQlXtXVi2VwD/E4lfSWZFa/mryWcbTw9Ix8zHGBc77i7EKQvr
         sMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUSv/leba9Q8axsenHUf6zXYFVRcTyGLlPdp1AvGirA=;
        b=Z30b4HIoFbhN1VBJMA7Ppj7GozwoTXfbroMBrl6aDK/xkOCDfOXMEtEC4EVPj3oABn
         RlmuzeWk5uqjGvV+FkEXTrMeuOTf7b/ewo+znWEXUPIa+9GlFJSFEuua2I3APbCdu7Bp
         +4rWeEuryXiLTUacISC1BCV4E3szK+nDm4J3uFJuBppWVkaTKwuMcqvtqryiTRlCsk7l
         o7bQCytZrsIiFAqmaBh2TGfliKZ7pp9LWl9zf4aeOOn6DsVgMf4aqKbZdXTmWkFbXMGi
         KmT1lgtnvDBbgT1bzurawIKR713YH28OXUoo26xYeb9cfvPcIjG3rnLi8w2YTIhBREUR
         +0mQ==
X-Gm-Message-State: AFqh2kokgLZ0EL3wVf4c0NSYmARFkR2Rc6h6Jvfwzb823daoXPIjKKsC
        6WuGwO2fZ1RXDNsGTIos1aw=
X-Google-Smtp-Source: AMrXdXt/MddaeJmBDvEOtwTLEkRefIyHiJ+1xi+k503MqBN9qtpwKWFx3A/YiYTBlQvisEVDbs9J9Q==
X-Received: by 2002:aca:654c:0:b0:35e:4002:d914 with SMTP id j12-20020aca654c000000b0035e4002d914mr18450549oiw.2.1672708414237;
        Mon, 02 Jan 2023 17:13:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q3-20020a056808200300b0035e461d9b1bsm12577911oiw.50.2023.01.02.17.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 17:13:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 2 Jan 2023 17:13:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <20230103011332.GB149144@roeck-us.net>
References: <20230102110551.509937186@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
