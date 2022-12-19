Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93277650A16
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 11:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiLSK2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 05:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiLSK2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 05:28:13 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF82DFF
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 02:27:59 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id p36so12918921lfa.12
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 02:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCwINa/Xyynd5tKM8WbncyIZot9QQcVukVXJMMrbO+o=;
        b=iGxI+wRN5xrUTGjqFuxyWRtox8T6IG7ZG3xWE5AVXwd/bCSzJinPsjwjUmKu11B9lG
         FS9Aky8yuUEn5bZp+hD5zVjtMlX18qyQARvcNCNryv/Vxh8bXsugl+Y9Jx5w/E7kwJ1B
         lhyixsq0SLJb/J2Zcd6479uZKdETbbyxnaxPtQjN43T3EDH2Avv3HDXMQGNHCaZLmESz
         1HRSuLjAbLv3lR0L4BfhJQAhD+C6b3QK3Rzdp468kEuDZXyzrlcKEUxTPkfVSGZoFjnd
         iQES+qIuxCpjRpQGUdi0TdmgWXCJKONX4es6jl0gU6lQL2v1ZVz7f0nBavON+9s4kEog
         lsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCwINa/Xyynd5tKM8WbncyIZot9QQcVukVXJMMrbO+o=;
        b=iXsWvct5ojs9lws5tx2kUMZkYp+jttklR4YLtHg3KBZ5Qvd4YJSNDhJI2oROu7u/M0
         YPh9iZQbfpYrhPPtgL53VRJOvaP1H4G5WzW82VvMyVEdaWMQ12QspA7FTgGvFUuyhCvZ
         NfxWLqGHN5UoO3iIfxsmEYCIXnDX+adqqXP/GN3i1bvotjjhL0nYZpAbjzWv2CH73kJh
         2+q4vArcwQvwQG6pYe4lNLt+Wlfe8B+ghAjGm5jNUxIIf8S7QJwBxx9VHK9gBZwZPfuQ
         fOHzPsE3KUun3dXBLLv+BvW/j4mY/v3khXuvl3iMxWhLevV7gAY8/e+yzgUCM7numc9e
         tKKg==
X-Gm-Message-State: ANoB5pmx3SOtfunngEEwd/SOfuS1OY0fgjNJyPflZiVHD3/+I3A5DvMo
        PXwBphgcR6NExV2WP5oqD6pWkyMc9sOszePrjP4=
X-Google-Smtp-Source: AA0mqf6GS1DCVpVD986kde0rUppyINGFBT1T4azIjO802Jr+L98lOMmng8sQVRMOn6Gf4+wu9pwJAzNOXHLddhg//50=
X-Received: by 2002:ac2:546a:0:b0:4b5:7d6e:5fe7 with SMTP id
 e10-20020ac2546a000000b004b57d6e5fe7mr6187711lfn.469.1671445677614; Mon, 19
 Dec 2022 02:27:57 -0800 (PST)
MIME-Version: 1.0
References: <20221216113456.414183-1-matthew.auld@intel.com> <CAHzEqDn8Vyrsidv14tU6dwxxf4oP1S-ZgNW7MJiwhcJm6NJeAQ@mail.gmail.com>
In-Reply-To: <CAHzEqDn8Vyrsidv14tU6dwxxf4oP1S-ZgNW7MJiwhcJm6NJeAQ@mail.gmail.com>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Mon, 19 Dec 2022 10:27:30 +0000
Message-ID: <CAM0jSHNWHdCE1Z0h8DMXV_=-bEFMbcVFHMwuzW10q2twm3dRKQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: improve the catch-all evict to
 handle lock contention
To:     Mani Milani <mani@chromium.org>
Cc:     Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Andrzej Hajda <andrzej.hajda@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 18 Dec 2022 at 23:50, Mani Milani <mani@chromium.org> wrote:
>
> Thank you for updating the docs Matthew. I am looking forward to this
> patch landing.

Pushed to drm-intel-gt-next. Thanks for the reviews.

>
> On Fri, Dec 16, 2022 at 10:35 PM Matthew Auld <matthew.auld@intel.com> wr=
ote:
> >
> > The catch-all evict can fail due to object lock contention, since it
> > only goes as far as trylocking the object, due to us already holding th=
e
> > vm->mutex. Doing a full object lock here can deadlock, since the
> > vm->mutex is always our inner lock. Add another execbuf pass which drop=
s
> > the vm->mutex and then tries to grab the object will the full lock,
> > before then retrying the eviction. This should be good enough for now t=
o
> > fix the immediate regression with userspace seeing -ENOSPC from execbuf
> > due to contended object locks during GTT eviction.
> >
> > v2 (Mani)
> >   - Also revamp the docs for the different passes.
> >
> > Testcase: igt@gem_ppgtt@shrink-vs-evict-*
> > Fixes: 7e00897be8bf ("drm/i915: Add object locking to i915_gem_evict_fo=
r_node and i915_gem_evict_something, v2.")
> > References: https://gitlab.freedesktop.org/drm/intel/-/issues/7627
> > References: https://gitlab.freedesktop.org/drm/intel/-/issues/7570
> > References: https://bugzilla.mozilla.org/show_bug.cgi?id=3D1779558
> > Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> > Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> > Cc: Mani Milani <mani@chromium.org>
> > Cc: <stable@vger.kernel.org> # v5.18+
> > Reviewed-by: Mani Milani <mani@chromium.org>
> > Tested-by: Mani Milani <mani@chromium.org>
> > ---
> >  .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 59 +++++++++++++++----
> >  drivers/gpu/drm/i915/gem/i915_gem_mman.c      |  2 +-
> >  drivers/gpu/drm/i915/i915_gem_evict.c         | 37 ++++++++----
> >  drivers/gpu/drm/i915/i915_gem_evict.h         |  4 +-
> >  drivers/gpu/drm/i915/i915_vma.c               |  2 +-
> >  .../gpu/drm/i915/selftests/i915_gem_evict.c   |  4 +-
> >  6 files changed, 82 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/g=
pu/drm/i915/gem/i915_gem_execbuffer.c
> > index 192bb3f10733..f98600ca7557 100644
> > --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> > +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> > @@ -733,32 +733,69 @@ static int eb_reserve(struct i915_execbuffer *eb)
> >         bool unpinned;
> >
> >         /*
> > -        * Attempt to pin all of the buffers into the GTT.
> > -        * This is done in 2 phases:
> > +        * We have one more buffers that we couldn't bind, which could =
be due to
> > +        * various reasons. To resolve this we have 4 passes, with ever=
y next
> > +        * level turning the screws tighter:
> >          *
> > -        * 1. Unbind all objects that do not match the GTT constraints =
for
> > -        *    the execbuffer (fenceable, mappable, alignment etc).
> > -        * 2. Bind new objects.
> > +        * 0. Unbind all objects that do not match the GTT constraints =
for the
> > +        * execbuffer (fenceable, mappable, alignment etc). Bind all ne=
w
> > +        * objects.  This avoids unnecessary unbinding of later objects=
 in order
> > +        * to make room for the earlier objects *unless* we need to def=
ragment.
> >          *
> > -        * This avoid unnecessary unbinding of later objects in order t=
o make
> > -        * room for the earlier objects *unless* we need to defragment.
> > +        * 1. Reorder the buffers, where objects with the most restrict=
ive
> > +        * placement requirements go first (ignoring fixed location buf=
fers for
> > +        * now).  For example, objects needing the mappable aperture (t=
he first
> > +        * 256M of GTT), should go first vs objects that can be placed =
just
> > +        * about anywhere. Repeat the previous pass.
> >          *
> > -        * Defragmenting is skipped if all objects are pinned at a fixe=
d location.
> > +        * 2. Consider buffers that are pinned at a fixed location. Als=
o try to
> > +        * evict the entire VM this time, leaving only objects that we =
were
> > +        * unable to lock. Try again to bind the buffers. (still using =
the new
> > +        * buffer order).
> > +        *
> > +        * 3. We likely have object lock contention for one or more stu=
bborn
> > +        * objects in the VM, for which we need to evict to make forwar=
d
> > +        * progress (perhaps we are fighting the shrinker?). When evict=
ing the
> > +        * VM this time around, anything that we can't lock we now trac=
k using
> > +        * the busy_bo, using the full lock (after dropping the vm->mut=
ex to
> > +        * prevent deadlocks), instead of trylock. We then continue to =
evict the
> > +        * VM, this time with the stubborn object locked, which we can =
now
> > +        * hopefully unbind (if still bound in the VM). Repeat until th=
e VM is
> > +        * evicted. Finally we should be able bind everything.
> >          */
> > -       for (pass =3D 0; pass <=3D 2; pass++) {
> > +       for (pass =3D 0; pass <=3D 3; pass++) {
> >                 int pin_flags =3D PIN_USER | PIN_VALIDATE;
> >
> >                 if (pass =3D=3D 0)
> >                         pin_flags |=3D PIN_NONBLOCK;
> >
> >                 if (pass >=3D 1)
> > -                       unpinned =3D eb_unbind(eb, pass =3D=3D 2);
> > +                       unpinned =3D eb_unbind(eb, pass >=3D 2);
> >
> >                 if (pass =3D=3D 2) {
> >                         err =3D mutex_lock_interruptible(&eb->context->=
vm->mutex);
> >                         if (!err) {
> > -                               err =3D i915_gem_evict_vm(eb->context->=
vm, &eb->ww);
> > +                               err =3D i915_gem_evict_vm(eb->context->=
vm, &eb->ww, NULL);
> > +                               mutex_unlock(&eb->context->vm->mutex);
> > +                       }
> > +                       if (err)
> > +                               return err;
> > +               }
> > +
> > +               if (pass =3D=3D 3) {
> > +retry:
> > +                       err =3D mutex_lock_interruptible(&eb->context->=
vm->mutex);
> > +                       if (!err) {
> > +                               struct drm_i915_gem_object *busy_bo =3D=
 NULL;
> > +
> > +                               err =3D i915_gem_evict_vm(eb->context->=
vm, &eb->ww, &busy_bo);
> >                                 mutex_unlock(&eb->context->vm->mutex);
> > +                               if (err && busy_bo) {
> > +                                       err =3D i915_gem_object_lock(bu=
sy_bo, &eb->ww);
> > +                                       i915_gem_object_put(busy_bo);
> > +                                       if (!err)
> > +                                               goto retry;
> > +                               }
> >                         }
> >                         if (err)
> >                                 return err;
> > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm=
/i915/gem/i915_gem_mman.c
> > index d73ba0f5c4c5..4f69bff63068 100644
> > --- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> > +++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> > @@ -369,7 +369,7 @@ static vm_fault_t vm_fault_gtt(struct vm_fault *vmf=
)
> >                 if (vma =3D=3D ERR_PTR(-ENOSPC)) {
> >                         ret =3D mutex_lock_interruptible(&ggtt->vm.mute=
x);
> >                         if (!ret) {
> > -                               ret =3D i915_gem_evict_vm(&ggtt->vm, &w=
w);
> > +                               ret =3D i915_gem_evict_vm(&ggtt->vm, &w=
w, NULL);
> >                                 mutex_unlock(&ggtt->vm.mutex);
> >                         }
> >                         if (ret)
> > diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i9=
15/i915_gem_evict.c
> > index 4cfe36b0366b..c02ebd6900ae 100644
> > --- a/drivers/gpu/drm/i915/i915_gem_evict.c
> > +++ b/drivers/gpu/drm/i915/i915_gem_evict.c
> > @@ -441,6 +441,11 @@ int i915_gem_evict_for_node(struct i915_address_sp=
ace *vm,
> >   * @vm: Address space to cleanse
> >   * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evic=
t_vm
> >   * will be able to evict vma's locked by the ww as well.
> > + * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NU=
LL, then
> > + * in the event i915_gem_evict_vm() is unable to trylock an object for=
 eviction,
> > + * then @busy_bo will point to it. -EBUSY is also returned. The caller=
 must drop
> > + * the vm->mutex, before trying again to acquire the contended lock. T=
he caller
> > + * also owns a reference to the object.
> >   *
> >   * This function evicts all vmas from a vm.
> >   *
> > @@ -450,7 +455,8 @@ int i915_gem_evict_for_node(struct i915_address_spa=
ce *vm,
> >   * To clarify: This is for freeing up virtual address space, not for f=
reeing
> >   * memory in e.g. the shrinker.
> >   */
> > -int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_w=
w_ctx *ww)
> > +int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_w=
w_ctx *ww,
> > +                     struct drm_i915_gem_object **busy_bo)
> >  {
> >         int ret =3D 0;
> >
> > @@ -482,15 +488,22 @@ int i915_gem_evict_vm(struct i915_address_space *=
vm, struct i915_gem_ww_ctx *ww)
> >                          * the resv is shared among multiple objects, w=
e still
> >                          * need the object ref.
> >                          */
> > -                       if (dying_vma(vma) ||
> > +                       if (!i915_gem_object_get_rcu(vma->obj) ||
> >                             (ww && (dma_resv_locking_ctx(vma->obj->base=
.resv) =3D=3D &ww->ctx))) {
> >                                 __i915_vma_pin(vma);
> >                                 list_add(&vma->evict_link, &locked_evic=
tion_list);
> >                                 continue;
> >                         }
> >
> > -                       if (!i915_gem_object_trylock(vma->obj, ww))
> > +                       if (!i915_gem_object_trylock(vma->obj, ww)) {
> > +                               if (busy_bo) {
> > +                                       *busy_bo =3D vma->obj; /* holds=
 ref */
> > +                                       ret =3D -EBUSY;
> > +                                       break;
> > +                               }
> > +                               i915_gem_object_put(vma->obj);
> >                                 continue;
> > +                       }
> >
> >                         __i915_vma_pin(vma);
> >                         list_add(&vma->evict_link, &eviction_list);
> > @@ -498,25 +511,29 @@ int i915_gem_evict_vm(struct i915_address_space *=
vm, struct i915_gem_ww_ctx *ww)
> >                 if (list_empty(&eviction_list) && list_empty(&locked_ev=
iction_list))
> >                         break;
> >
> > -               ret =3D 0;
> >                 /* Unbind locked objects first, before unlocking the ev=
iction_list */
> >                 list_for_each_entry_safe(vma, vn, &locked_eviction_list=
, evict_link) {
> >                         __i915_vma_unpin(vma);
> >
> > -                       if (ret =3D=3D 0)
> > +                       if (ret =3D=3D 0) {
> >                                 ret =3D __i915_vma_unbind(vma);
> > -                       if (ret !=3D -EINTR) /* "Get me out of here!" *=
/
> > -                               ret =3D 0;
> > +                               if (ret !=3D -EINTR) /* "Get me out of =
here!" */
> > +                                       ret =3D 0;
> > +                       }
> > +                       if (!dying_vma(vma))
> > +                               i915_gem_object_put(vma->obj);
> >                 }
> >
> >                 list_for_each_entry_safe(vma, vn, &eviction_list, evict=
_link) {
> >                         __i915_vma_unpin(vma);
> > -                       if (ret =3D=3D 0)
> > +                       if (ret =3D=3D 0) {
> >                                 ret =3D __i915_vma_unbind(vma);
> > -                       if (ret !=3D -EINTR) /* "Get me out of here!" *=
/
> > -                               ret =3D 0;
> > +                               if (ret !=3D -EINTR) /* "Get me out of =
here!" */
> > +                                       ret =3D 0;
> > +                       }
> >
> >                         i915_gem_object_unlock(vma->obj);
> > +                       i915_gem_object_put(vma->obj);
> >                 }
> >         } while (ret =3D=3D 0);
> >
> > diff --git a/drivers/gpu/drm/i915/i915_gem_evict.h b/drivers/gpu/drm/i9=
15/i915_gem_evict.h
> > index e593c530f9bd..bf0ee0e4fe60 100644
> > --- a/drivers/gpu/drm/i915/i915_gem_evict.h
> > +++ b/drivers/gpu/drm/i915/i915_gem_evict.h
> > @@ -11,6 +11,7 @@
> >  struct drm_mm_node;
> >  struct i915_address_space;
> >  struct i915_gem_ww_ctx;
> > +struct drm_i915_gem_object;
> >
> >  int __must_check i915_gem_evict_something(struct i915_address_space *v=
m,
> >                                           struct i915_gem_ww_ctx *ww,
> > @@ -23,6 +24,7 @@ int __must_check i915_gem_evict_for_node(struct i915_=
address_space *vm,
> >                                          struct drm_mm_node *node,
> >                                          unsigned int flags);
> >  int i915_gem_evict_vm(struct i915_address_space *vm,
> > -                     struct i915_gem_ww_ctx *ww);
> > +                     struct i915_gem_ww_ctx *ww,
> > +                     struct drm_i915_gem_object **busy_bo);
> >
> >  #endif /* __I915_GEM_EVICT_H__ */
> > diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i91=
5_vma.c
> > index 34f0e6c923c2..7d044888ac33 100644
> > --- a/drivers/gpu/drm/i915/i915_vma.c
> > +++ b/drivers/gpu/drm/i915/i915_vma.c
> > @@ -1599,7 +1599,7 @@ static int __i915_ggtt_pin(struct i915_vma *vma, =
struct i915_gem_ww_ctx *ww,
> >                          * locked objects when called from execbuf when=
 pinning
> >                          * is removed. This would probably regress badl=
y.
> >                          */
> > -                       i915_gem_evict_vm(vm, NULL);
> > +                       i915_gem_evict_vm(vm, NULL, NULL);
> >                         mutex_unlock(&vm->mutex);
> >                 }
> >         } while (1);
> > diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c b/drivers/=
gpu/drm/i915/selftests/i915_gem_evict.c
> > index 8c6517d29b8e..37068542aafe 100644
> > --- a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
> > +++ b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
> > @@ -344,7 +344,7 @@ static int igt_evict_vm(void *arg)
> >
> >         /* Everything is pinned, nothing should happen */
> >         mutex_lock(&ggtt->vm.mutex);
> > -       err =3D i915_gem_evict_vm(&ggtt->vm, NULL);
> > +       err =3D i915_gem_evict_vm(&ggtt->vm, NULL, NULL);
> >         mutex_unlock(&ggtt->vm.mutex);
> >         if (err) {
> >                 pr_err("i915_gem_evict_vm on a full GGTT returned err=
=3D%d]\n",
> > @@ -356,7 +356,7 @@ static int igt_evict_vm(void *arg)
> >
> >         for_i915_gem_ww(&ww, err, false) {
> >                 mutex_lock(&ggtt->vm.mutex);
> > -               err =3D i915_gem_evict_vm(&ggtt->vm, &ww);
> > +               err =3D i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
> >                 mutex_unlock(&ggtt->vm.mutex);
> >         }
> >
> > --
> > 2.38.1
> >
