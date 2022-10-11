Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F385FB750
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJKPcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiJKPcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:32:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26CA25C7A;
        Tue, 11 Oct 2022 08:21:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pq16so12784414pjb.2;
        Tue, 11 Oct 2022 08:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S3UpNmTeywE4rPFC/bU60EQyRPN5i2bEk0jHJzGD5KI=;
        b=ooe7ik/7fJqbiSJUa0U/Az2hbrsKrjHnlKG3JT9K6TPWlbW1i52A5eLnqmcpXdlI7t
         17P7vOy1QBeJtg4THhq/EA5pVszvsIiC/pPy8FZoLpxZxHFS75l9bqln15TyOYqPLRzE
         OE6ltZ8RNBvjVtU8Vbbd/SVYrJquvbx+dZmaLR1fiX2L5923Jz8X4JOwEz8HhKUMkaj2
         anESbWpBK4mFqO18yi/iT+qKhOjWr+yljrYHjjkEXy9GhKkrSxur3vMowsNdppyKCVoY
         FuOuhDVPj+fPO7FxrBHgcN+Z59xgAuQ8ww2byksB+AR9KiTcRyxv/+iwcGRy8WfEE7wo
         No5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S3UpNmTeywE4rPFC/bU60EQyRPN5i2bEk0jHJzGD5KI=;
        b=NarvRXgNMBJycoY42UNfE5CdexvAx+zAVxRCYoFNmoF+IuQtZ09FKF3cJQB/cpXHNi
         3ZpN1eP3NvEujAueXDT51INFfRIxFhRAJVsU7Gad0qkLxZ0w55QLClrblfAHNjR4DQs4
         js+8QJxf0mVJssyIWcrn4tusY7i4KetKnuko33iGJJixesHdsPzuiHS/W97RkstMx08G
         XTt1Xw3jAQ5Q8ZhGkGnDKb9S4VCpMSIO2juR+ME0wdMcF1BBhGCCK4E+/9YiTpmMjrXy
         5RHWS2UgVKkw9yu6nit4xpQ0UlXAsA6VJRm0V5TYYnxTUBGDuHw8RwSC/Ps9Jg3XSEaM
         4KMQ==
X-Gm-Message-State: ACrzQf1aqOLYcG3L91LzxhfCZ7rO8hjXCq42rYSRMgaLA/zjnaoJD1ga
        Mv7WUfN9BRwcSHuck/WzXD8=
X-Google-Smtp-Source: AMsMyM45B5QMQvKNI+mg5a5XzGECHWw2G3zKx6dWg9D0CnojfcuP7i3npNdJh4sCemEVF9nIsT+VNw==
X-Received: by 2002:a17:90b:3b45:b0:20c:2eae:e70 with SMTP id ot5-20020a17090b3b4500b0020c2eae0e70mr22884043pjb.240.1665501711901;
        Tue, 11 Oct 2022 08:21:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b0017f75654a33sm2254019plk.73.2022.10.11.08.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 08:21:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 11 Oct 2022 08:21:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
Message-ID: <20221011152010.GA3994805@roeck-us.net>
References: <20221010191226.167997210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
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

On Mon, Oct 10, 2022 at 09:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 486 pass: 486 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
