Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1356D67FA8B
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 20:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjA1Tto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 14:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjA1Ttn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 14:49:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197F20069
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 11:49:41 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g11so7539821eda.12
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 11:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sO7UFPAZ5ipITcECO24P9uQ1IShk8QTj6My2HieSQws=;
        b=jzNVGVvTE2HFKVLCwGxGV1dUHlVW8dNZgwyoIV9lHAH+2iLiAYLDSh+EoLMuYfd/Kq
         T21cf2WfHBFlsn0twy6N/xRHUhE0IuItx9yPTe8n12qoTogyJNItLKXiCKfBdTMFAeYm
         WRErPYPzETrojUHHGV0t3MpnI1YzI7sroDzl0qiV5P5ofgLso57SWFPBRp6ArVpejOvA
         hTcXsTyzsm8tBw6CtwYzdRNHVzqONhPJS1+nohjz8GbRMdkaU/yY7Uxt6w83au7wIHYS
         V9+EnhDzzevExl9Wu9vXJoDsiGr0bKKxlEszeZ40lZ49Lyw72RjVk+TFB3leXe0uaJbn
         Oy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sO7UFPAZ5ipITcECO24P9uQ1IShk8QTj6My2HieSQws=;
        b=gghsOLXqYn7iMI/6pSTmZkXv3qqoUPORvUhr1uMOVHO/TefFbeNIYOdyTJdQ6BCjc1
         en9LEVPgeBFu/OS7s2UOzCkyNTbaSgt896ca00maBQ3HVTiaXv313golPxiLY/ZnCr72
         +nZc+dh6ox9j9JcAq106SFX1zxx+TebFSGIvAQVw3lgCxW6+2IBm01jR6LvkBTQ9/2KY
         FgEyYh1zI/QAIiBbPRGKdHhVfAnGxmPnQuqPmfH9LLVX05/WGawK/uOhm/Ba1oQR0B6s
         5P+sCz2fd5jOnj6em48+7utLnCWkhfAqmDmFbzNIkWJwad1SUSKiSzXOBhrFGPZqRLpS
         51wA==
X-Gm-Message-State: AFqh2kp7aJt9BMFPwJxceCJGQD077PROnbkdweMtm7S1mUAX6/lARHUQ
        oOyRfNaje+nGuNLfXenFMhA=
X-Google-Smtp-Source: AMrXdXtAcT3gd3LmQFK4oXM1qMxTHcdxecJwUH68lFyOEcOfZg75/8qWSlJJB7LZsJr7ngQJx9uH3A==
X-Received: by 2002:a05:6402:294c:b0:48e:c0c3:7974 with SMTP id ed12-20020a056402294c00b0048ec0c37974mr50319656edb.12.1674935380045;
        Sat, 28 Jan 2023 11:49:40 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id g5-20020a50ee05000000b004835bd8dfe5sm4334889eds.35.2023.01.28.11.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 11:49:39 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id AB9F6BE2DE0; Sat, 28 Jan 2023 20:49:38 +0100 (CET)
Date:   Sat, 28 Jan 2023 20:49:38 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Computer Enthusiastic <computer.enthusiastic@gmail.com>,
        stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        Lyude Paul <lyude@redhat.com>
Subject: Re: [Nouveau] [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
Message-ID: <Y9V8UoUHm3rHcDkc@eldamar.lan>
References: <20220819200928.401416-1-kherbst@redhat.com>
 <CAHSpYy0HAifr4f+z64h+xFUmMNbB4hCR1r2Z==TsB4WaHatQqg@mail.gmail.com>
 <CACO55tv0jO2TmuWcwFiAUQB-__DZVwhv7WNN9MfgMXV053gknw@mail.gmail.com>
 <CAHSpYy117N0A1QJKVNmFNii3iL9mU71_RusiUo5ZAMcJZciM-g@mail.gmail.com>
 <cdfc26b5-c045-5f93-b553-942618f0983a@gmail.com>
 <Y9VgjLneuqkl+Y87@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9VgjLneuqkl+Y87@kroah.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I'm not the reporter, so would like to confirm him explicitly, but I
believe I can give some context:

On Sat, Jan 28, 2023 at 06:51:08PM +0100, Greg KH wrote:
> On Sat, Jan 28, 2023 at 03:49:59PM +0100, Computer Enthusiastic wrote:
> > Hello,
> > 
> > The patch "[Nouveau] [PATCH] nouveau: explicitly wait on the fence in
> > nouveau_bo_move_m2mf" [1] was marked for kernels v5.15+ and it was merged
> > upstream.
> > 
> > The same patch [1] works with kernel 5.10.y, but it is not been merged
> > upstream so far.
> > 
> > According to Karol Herbst suggestion [2], I'm sending this message to ask
> > for merging it into 5.10 kernel.
> 
> We need to know the git commit id.  And have you tested it on 5.10.y?
> And why are you stuck on 5.10.y for this type of hardware?  Why not move
> to 5.15.y or 6.1.y?

This would be commit 6b04ce966a73 ("nouveau: explicitly wait on the
fence in nouveau_bo_move_m2mf") in mainline, applied in 6.0-rc3 and
backported to 5.19.6 and 5.15.64.

Computer Enthusiastic, tested it on 5.10.y: 
https://lore.kernel.org/nouveau/CAHSpYy1mcTns0JS6eivjK82CZ9_ajSwH-H7gtDwCkNyfvihaAw@mail.gmail.com/

It was reported in Debian by the user originally as
https://bugs.debian.org/989705#69 after updating to the 5.10.y series in Debian
bullseye.

I guess the user could move to the next stable release Debian bookworm, once
it's released (it's currently in the last milestones to finalize, cf.
https://release.debian.org/ but we are not yet there). In the next release this
will be automatically be fixed indeed.

Computer Enthusiastic, can you confirm please to Greg in particular the first
questions, in particular to confirm the commit fixes the suspend issue?

Regards,
Salvatore
