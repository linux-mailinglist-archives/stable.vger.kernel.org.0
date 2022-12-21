Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D71A652ABD
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 02:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLUBIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 20:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUBIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 20:08:41 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5C7165AB;
        Tue, 20 Dec 2022 17:08:40 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1447c7aa004so17516171fac.11;
        Tue, 20 Dec 2022 17:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iK4iz97VIr1jVXuQzZLBdQNi9qt+PjrObZGgfMDl/Js=;
        b=cTnzhn2Thhc8aTUwGh512oQ5NCw0sMMB8exZiXzZySYK3WQSo5FqUJAP3JmkugQ2yB
         bHz7OxURxfTqvzDVfQcxs5Y0U4ckeaFr0AS7xyhGBfhA7uS5MnZIjm4+9nwRjYrIzSRu
         9GvUv0RPMfkAl39ERbewSY45Xyt+WqP2EbZK05EGH4wqGdHSl6d/+mdcWKZ8L7Ew+0Ug
         tf72oK/EnzCgTWkwSPMZ2v+zi8FZZTYcsYHrmYBCOYy3qOVwpUeLJEdYTYXhv4HfWi9l
         W08ijnwnUDezzBVSmvNTJ9h9CGFDH3MHG5+c7ooGrDu54Om18DN+eTO3XX+twfH+2p63
         4Teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iK4iz97VIr1jVXuQzZLBdQNi9qt+PjrObZGgfMDl/Js=;
        b=G1gqsmnT6bu7hw3rIA6qJrSvGh0uUvjzNGGREqyiQzG5PtE4oN5u9zA5AZx73K5k0z
         a5D9QJ732v4InbQCk94zD/czjIHXxRLMyA3Cydeo8+trpeO6AQmUaehbLJSxZPgCsvQW
         fCfdosLcybsa2c4QdcR4ujQNZP8Qe+4HvsgHhIdRnI/Y5frWmQmw+QXj+wWvx6GzgYBn
         u2PF1hVygnCW9pSjebuA9aZf3Zpa6hY6loTiCYXwMgFlvtK72KiVSzzOLnGdn3XF9ANw
         4gjxmzODcxo1KDsaq/fkksOdnCBj3L/ezZOIteLsbwQUQ1MFvMDR+iy2EHCss9Kzi3Y9
         dipw==
X-Gm-Message-State: ANoB5pnT6cL8Pb4RQ+AHnlyroC1lJyX/ty88NVn63oYlf4+oPpM9VQ6L
        e0I5HLt82mWn+Upme/a2MLc=
X-Google-Smtp-Source: AA0mqf6CTOyTXWJ4MN4lwh5oUlQkXY1H8ltwuapni1WU2l8SjdbXyl9UGeYoza47S+UBXPOIdDN1lg==
X-Received: by 2002:a05:6870:a117:b0:144:3ed1:1ec2 with SMTP id m23-20020a056870a11700b001443ed11ec2mr25304464oae.43.1671584919870;
        Tue, 20 Dec 2022 17:08:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3-20020a056870890300b001446d5702b5sm6640256oao.56.2022.12.20.17.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 17:08:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 17:08:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <20221221010838.GB1319848@roeck-us.net>
References: <20221219182940.739981110@linuxfoundation.org>
 <20221220144835.GC3748047@roeck-us.net>
 <20221220153328.GB907923@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220153328.GB907923@roeck-us.net>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 07:33:29AM -0800, Guenter Roeck wrote:
> On Tue, Dec 20, 2022 at 06:48:37AM -0800, Guenter Roeck wrote:
> > On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.85 release.
> > > There are 17 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 155 fail: 0
> > Qemu test results:
> > 	total: 489 pass: 489 fail: 0
> > 
> 
> Wrong results, sorry. I'll resend once I have the real ones.
> 

Real test results:

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 487 fail: 2
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:net,default:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:usb0:mem128:zynq-zed:rootfs

Guenter
