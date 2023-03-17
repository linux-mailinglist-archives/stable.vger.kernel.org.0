Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0DA6BEE2D
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 17:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCQQ2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 12:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCQQ2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 12:28:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC12A163
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 09:28:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cy23so22504586edb.12
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 09:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679070488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sM+dgA1qJekrwZUnv1JRioekXpIxgoz4g8TBkXglJrg=;
        b=ERIurE41vo/1q7+ch26aXDWBoDa6ERGJoxkX2agpSlOzlN0G6f+SUkpJGXDs1/AqeJ
         IU7hRV/3VB0J4dYk0lcil8hiW0T9vOG16lKHppFUezP+QOPJK1Jr8xcFR7mMC2+ON7dP
         69WL96k28ZqMAA53w0ES0hAnZLD7qbuyPOWCWnMxqap6uBUmgxgZMi46ozT/LcKMANIG
         g2kfHGtGVENleOx640sfvI+i1h7dMtxooPePFmdyU+S0sbRTEF2cfz5b0wqF1/Cf9va7
         eaI1/ZgqEK4RN49XBRQsqXfAknMQpaZyR0vFpoZmaegOikFYwQJq8wGaVUjvGqTbQK8s
         KcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sM+dgA1qJekrwZUnv1JRioekXpIxgoz4g8TBkXglJrg=;
        b=2Z1AHvF7gNSF8d9x6gD6j7Ka+sKMdD72pY+a2EBGZCvTW5ZeqkrWA4iNUvpZ61S8e1
         MKhyhIyDmAI99u+qB/qi1pRyLbFGtJaAgesgikziYWee0BW7tb0BDdMPjEi4tY+NMNS6
         8eYu6zYMnIKmXkKjoS9l0WXjhR36NrJTknd5ghbeO5x2An1CbqrK6mI/Wi2FjT7dXenU
         rGv8pUaOhd9PBIclBk8VU8VdwAewFNckUAVi8+eRms6hZc7E9V9sguOWHJUZV6ac5T5u
         YpWvugiLL0A1Z1ILBWAbEb/OzmXA6eKXSW/LMCGAO2vuJiXWImNxuVqPdnZWFP3kt7J4
         KT+w==
X-Gm-Message-State: AO0yUKWFDvUm5msjR6lF+LQtn8x9RN2CHN+6qywDYS3vj4llJPFGlwN1
        yL/K4bPC8iXz4CPVfTnkh5MJxqTFvUaBDU/o7IQxd0KMrcA=
X-Google-Smtp-Source: AK7set/t2C7YiSG4njN2lPhwC/PbBKecrkAqU4JdADOsqb4X3uxx37D/X05JZ6VpBn9NXnJ4svHDNw1CtdTeBBIsbU0=
X-Received: by 2002:a17:907:36e:b0:877:747d:4a85 with SMTP id
 rs14-20020a170907036e00b00877747d4a85mr7798535ejb.3.1679070488213; Fri, 17
 Mar 2023 09:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <167820543971229@kroah.com> <20230314022211.1393031-1-John.C.Harrison@Intel.com>
 <ZBF48kVhFmXIsR+K@kroah.com> <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
 <ZBIHJD5FkxiammjB@kroah.com> <5ed286b7-c2df-9e63-d85a-be9994f93eec@intel.com> <ZBRkAZwItdidH32z@kroah.com>
In-Reply-To: <ZBRkAZwItdidH32z@kroah.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Fri, 17 Mar 2023 12:27:56 -0400
Message-ID: <CAKf6xpvo6suOZWF1QKYp1fy3kyMhD05snebpSq5+ha5osPxJLg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 5.4.y] drm/i915: Don't use BAR mappings for
 ring buffers with LLC
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     John Harrison <john.c.harrison@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 17, 2023 at 8:58=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Mar 16, 2023 at 01:58:35PM -0700, John Harrison wrote:
> > On 3/15/2023 10:57, Greg KH wrote:
> > > On Wed, Mar 15, 2023 at 10:07:53AM -0700, John Harrison wrote:
> > > > On 3/15/2023 00:51, Greg KH wrote:
> > > > > On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.c=
om wrote:
> > > > > > From: John Harrison <John.C.Harrison@Intel.com>
> > > > > >
> > > > > > Direction from hardware is that ring buffers should never be ma=
pped
> > > > > > via the BAR on systems with LLC. There are too many caching pit=
falls
> > > > > > due to the way BAR accesses are routed. So it is safest to just=
 not
> > > > > > use it.
> > > > > >
> > > > > > Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> > > > > > Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound a=
nywhere")
> > > > > > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > > > > > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > > > > > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > > > > > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > > Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> > > > > > Cc: intel-gfx@lists.freedesktop.org
> > > > > > Cc: <stable@vger.kernel.org> # v4.9+
> > > > > > Tested-by: Jouni H=C3=B6gander <jouni.hogander@intel.com>
> > > > > > Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@inte=
l.com>
> > > > > > Link: https://patchwork.freedesktop.org/patch/msgid/20230216011=
101.1909009-3-John.C.Harrison@Intel.com
> > > > > > (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851=
d919)
> > > > > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > > > > (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e9=
0194)
> > > > > > Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> > > > > > ---
> > > > > >    drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
> > > > > >    1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > Also queued up for 5.10.y, you forgot that one :)
> > > > I'm still working through the backlog of them.
> > > >
> > > > Note that these patches must all be applied as a pair. The 'don't u=
se
> > > > stolen' can be applied in isolation but won't totally fix the probl=
em.
> > > > However, applying 'don't use BAR mappings' without applying the sto=
len patch
> > > > first will results in problems such as the failure to boot that was=
 recently
> > > > reported and resulted in a revert in one of the trees.
> > > I do not understand, you only submitted 1 patch here, what is the
> > > "pair"?
> > The original patch series was two patches -
> > https://patchwork.freedesktop.org/series/114080/. One to not use stolen
> > memory and the other to not use BAR mappings. If the anti-BAR patch is
> > applied without the anti-stolen patch then the i915 driver will attempt=
 to
> > access stolen memory directly which will fail. So both patches must be
> > applied and in the correct order to fix the problem of cache aliasing w=
hen
> > using BAR accesses on LLC systems.
> >
> > As above, I am working my way through the bunch of 'FAILED patch' email=
s.
> > The what-to-do instructions in those emails explicitly say to send the =
patch
> > individually in reply to the 'FAILED' message rather than as part of an=
y
> > original series.
>
> So what commits exactly in Linus's tree should be in these stable
> branches?  Sorry, I still do not understand if we are missing one or if
> we need to revert something.

Hi, Greg,

5.4.237 fails to boot as a Xen PV Dom0.  It hangs after modprobe
i915.ko with no further output, though it seems to response to magic
sysrq.

Reverting 5.4.y commit 1aed78cfda7f17f3cc71cb127a85a188eafc679a
("drm/i915: Don't use BAR mappings for ring buffers with LLC") lets it
boot properly.

Thanks,
Jason
