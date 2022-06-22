Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC49554FB0
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 17:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359441AbiFVPo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 11:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359422AbiFVPo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 11:44:58 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF5936B70;
        Wed, 22 Jun 2022 08:44:57 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e63so14941447pgc.5;
        Wed, 22 Jun 2022 08:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5oDfxiHmRZ/mXbqHpD2ytdlguA9TUQAUn4TSuFHpAtY=;
        b=YYKcVhQQ8EjoxBHld0QSfGM4XbttBnOMRXH0O3MlqUeFQlDsSSdmo3NP11tVMjoTei
         dldlJubjb9Ug9+a26LCLh3Tyzrjokl72oDPHpo+p0TmxhxTSslp9lcGYons3E9v+7URD
         XMXn3k1d5Mo9hNDAU5GKi186t2/5+pYfIbaaRSmG0eOx0XRB+Df9WZV+aN48js9bpbT7
         D2Ckjwcv56YNYbo/9vbC9uLxCO4PjqP17JCg9GiKhEvkq9Iy9D7xbw4kUa0zLjBAlxCk
         jRz0hIgB1nIIuX+yzZNpEsqBodOgi0UesAD0rOdVkDCLKRmXTmFMvAs5FTUU7UPI9ghx
         2WdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5oDfxiHmRZ/mXbqHpD2ytdlguA9TUQAUn4TSuFHpAtY=;
        b=4n/BYUBSj666FDLy5EbW+Z1r4GRHzLx2zm6lebRvjWtQgxYacbVmx3OL73D6oYyafJ
         UlOfztcD5Xd/KAvLYE4AMw1qNi5WNz5tEuG9vmm712QeIwWyCGNeqoAKZwfihmLyXcUY
         OKee0w8g81cCqJ+Ewkrutu8TLsR5lcDz6IsRAj5edmwZfpLwGLG/QlsVy0yXkv0mUPnD
         nL4b+qxC+b99z6FnNS4UBlSYKRhy2xmfR4OV8tcdKmmrzfPzE/C1Ktw3QXvj3S/IGybF
         ULQhpZOQ7kGZStguFOuCnFA+lTILboVUH8kgwgvQqnF3R02sOLntXqG7bQ+ChMWoavOO
         2oCw==
X-Gm-Message-State: AJIora+7vAxMXNY+ajF6qxVtAZlS/zV+BkupYPjTncrhuv+biZ2QkQkg
        EZjJUi4+tvJwJfG4muhUmnU=
X-Google-Smtp-Source: AGRyM1uMp1YdBusiL8ZThr7o7N2Hjf6y03sWmkLIwMrW6OJ9nKPLURpf05XsehpqNR/10i/nb9rr8Q==
X-Received: by 2002:a05:6a00:3006:b0:525:266a:852e with SMTP id ay6-20020a056a00300600b00525266a852emr15251504pfb.60.1655912696978;
        Wed, 22 Jun 2022 08:44:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o11-20020a63730b000000b003fadfd7be5asm13346730pgc.18.2022.06.22.08.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:44:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 22 Jun 2022 08:44:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Julian Haller <julian.haller@philips.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Message-ID: <20220622154454.GA1864037@roeck-us.net>
References: <20220622150234.GC1861763@roeck-us.net>
 <20220622153950.3001449-1-jhaller@bbl.ms.philips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622153950.3001449-1-jhaller@bbl.ms.philips.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 05:39:50PM +0200, Julian Haller wrote:
> > On Wed, Jun 22, 2022 at 04:49:01PM +0200, Julian Haller wrote:
> > > From: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> > > 
> > > The thermal subsystem registers a hwmon driver without providing
> > > chip or sysfs group information. This is for legacy reasons and
> > > would be difficult to change. At the same time, we want to enforce
> > > that chip information is provided when registering a hwmon device
> > > using hwmon_device_register_with_info(). To enable this, introduce
> > > a special API for use only by the thermal subsystem.
> > > 
> > > Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > 
> > What is the point of applying those patches to the 5.4 kernel ?
> > This was intended for use with new code, not for stable releases.
> > 
> > Guenter
> 
> The upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ("hwmon: Make chip
> parameter for with_info API mandatory") was backported to the 5.4 kernel as
> part of v5.4.198, see commit 1ec0bc72f5dab3ab367ae5230cf6f212d805a225. This
> breaks the hwmon device registration in the thermal drivers as these two
> patches here have been left out. We either need to include them as well or
> revert the original commit.
> 
> I'm also not sure why the original commit found its way into the 5.4 stable
> branch.
> 

I had complained about this backport to other branches before. That patch
was not a bug fix, it was neither intended nor marked for stable releases,
and it should be reverted from all stable branches.

Guenter
