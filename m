Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D802160D24C
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 19:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiJYRQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 13:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbiJYRQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 13:16:17 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9711157F55;
        Tue, 25 Oct 2022 10:16:16 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id cb2-20020a056830618200b00661b6e5dcd8so8164529otb.8;
        Tue, 25 Oct 2022 10:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wdbCZ4CHEVidOPRYp9p5sbBFoXVtuLvQpFWkZTNGqG8=;
        b=AzlwddO6tQinP8jw4jAugqQY958HFAM6LfcjRoiQACNTNMIX6pJHJ1v1cmKrI92Vmi
         3b/msy4x4LpoD+oS373Mu2FQv5mmIZVU70aVht9jHVZfbC8phTaMFtg0N4Fs5BZUOs1y
         bzzjq+Lk67EZ+Rw5rGcf96sM5OKnl+kGeI9EqNUVRCrdqwVgPghm8yXIwiTWI7vs2DtC
         Eyb35lZ9trThsZhe/7JQsCwFzJzLHbovlnpbkrEfXojNusXsrI0ND3ICxvHtsdt4nGxJ
         PCBGVslVr617J8MUaB+Cug2pLY7o6xQ83SMEUgl7IbjNkWqUGoz88v0K6dmM5cuZv0qd
         OFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wdbCZ4CHEVidOPRYp9p5sbBFoXVtuLvQpFWkZTNGqG8=;
        b=lAemjJd3AbGK4ir1zxBqBjHvntar7g/j8HLUBw2MNUxCfk9Pcuq3PSlte5Gttq1cN4
         cB9wcun5aj7cuxzxGUzmnbrAkbbQz6HcyBr7oNeHGq0FHjiDbkIg553fKRILMGKyGxex
         aecHl+gskRbvaJCJ4/vhbOrsPWdd77CLC/QPfqUeYYF1hfzx38u2Qg4bdppLKEujPUdb
         zWQ/ewGCjr7XS62M7K1Yo2LX/eMq6gvbtCtU8lo+XGX0TEQqOLZZcjboRIFvOVOu3H+f
         nXJRS140J+GZ9AA5/W8YVHDQurHcFrSsh/j1f3wwYKeVNNrNCpSjbx4/gxx4nTXVU7cF
         C3Hg==
X-Gm-Message-State: ACrzQf1GHQ/aKvW+aPzwtOEc+LHKQ50Fy85odXHmxPOgf7Ft3/r3Yzri
        hpfHmjVRKCLW7TlzGzcgmXaPL4iaZLs=
X-Google-Smtp-Source: AMsMyM5/KJoKTe1dHpKJNs/RLAnLytdPfzAEdK77gcjqf5hxyWbZpZc8Td0gXqB29a0fZ/Cwzs/WtQ==
X-Received: by 2002:a05:6830:4cb:b0:661:98d9:e2fd with SMTP id s11-20020a05683004cb00b0066198d9e2fdmr19965470otd.314.1666718176220;
        Tue, 25 Oct 2022 10:16:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z33-20020a056870462100b0012c21a64a76sm1726981oao.24.2022.10.25.10.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 10:16:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 Oct 2022 10:16:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Christian Bach <christian.bach@scs.ch>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Message-ID: <20221025171614.GB968059@roeck-us.net>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <Y1fYjmtQZa53dPfR@kroah.com>
 <ZR0P278MB077321F8565A4FF929B132A1EB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <5373483d-adde-2884-6017-75f3bd25d6bc@roeck-us.net>
 <ZR0P278MB0773212E08AA1007241990FCEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR0P278MB0773212E08AA1007241990FCEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
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

On Tue, Oct 25, 2022 at 04:17:27PM +0000, Christian Bach wrote:
> Ok
> 
> I now tested the whole thing also with some of the v5.4.y kernels. Just to avoid misunderstandings I listed all my tests below:
> 
> Kernel    | Hash                                       | Bug     | Comment
> Version   | (date)                                     | present |
> ----------|--------------------------------------------|---------|--------------

> ----------|--------------------------------------------|---------|--------------
> v5.10-rc1 | 3650b228f83adda7e5ee532e2b90429c03f7b9ec   | Yes     | This kernel behaves exactly like 5.15.74
>           | (25. October 2020)                         |         |
> ----------|--------------------------------------------|---------|--------------
> v5.4.219  | 35826e154ee014b64ccfa0d1f12d36b8f8a75939   | Yes     | This kernel performs segnificantly worse in
>           | (19. October 2022)                         | worse   |  nagotiating with the USP-PD power-supply and
>           |                                            |         |  even crashes about 50% of the tries. It then
>           |                                            |         |  gets stuck in the ISR just as it does 100%
>           |                                            |         |  of the time when connecting the USB-A to USB-C
>           |                                            |         |  cable. (and even when disconnecting the cable)

Thanks a lot for the detailed report. It would be great if you can
send actual crash logs. Maybe that problem is fixable in v5.4.y.

Can you also test v5.0 .. v5.3 ? Mainline would be best (not v5.0.x but v5.0) ?

> I would love to send some kernel logs but I can not see any entry in dmesg. Can you instruct me how to get the corresponding kernel logs?
> 

This won't be in dmesg; that would be way too noisy since it logs
each state machine action.

You should find the logs in /sys/debug/kernel/usb/tcpm-<index>.
In older kernels it is just a file, in more recent kernels it is a
directory with files in it. In really old kernels it is
/sys/debug/kernel/tcpm/tcpm-<index>. If you don't immediately find
the file(s), just search for files with "tcpm" in the name in
/sys/kernel/debug.

Hope this helps,

Thanks,
Guenter
