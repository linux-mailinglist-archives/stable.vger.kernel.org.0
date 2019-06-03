Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E1C3354C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 18:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfFCQxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 12:53:30 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35274 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfFCQxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 12:53:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id 48AD327FDB2
Subject: Re: [PATCH v3 5/5] drm: don't block fb changes for async plane
 updates
To:     Sean Paul <sean@poorly.run>
Cc:     dri-devel@lists.freedesktop.org, nicholas.kazlauskas@amd.com,
        andrey.grodzovsky@amd.com, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        boris.brezillon@collabora.com, David Airlie <airlied@linux.ie>,
        Sean Paul <seanpaul@google.com>, kernel@collabora.com,
        harry.wentland@amd.com,
        =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu@google.com>,
        stable@vger.kernel.org, Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        eric@anholt.net, robdclark@gmail.com,
        amd-gfx@lists.freedesktop.org,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        freedreno@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
References: <20190314002027.7833-1-helen.koike@collabora.com>
 <20190314002027.7833-6-helen.koike@collabora.com>
 <20190507201819.GI17077@art_vandelay>
From:   Helen Koike <helen.koike@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <38c84dc8-3687-ef6d-059f-92b902d2371c@collabora.com>
Date:   Mon, 3 Jun 2019 13:53:15 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507201819.GI17077@art_vandelay>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/7/19 5:18 PM, Sean Paul wrote:
> On Wed, Mar 13, 2019 at 09:20:26PM -0300, Helen Koike wrote:
>> In the case of a normal sync update, the preparation of framebuffers (be
>> it calling drm_atomic_helper_prepare_planes() or doing setups with
>> drm_framebuffer_get()) are performed in the new_state and the respective
>> cleanups are performed in the old_state.
>>
>> In the case of async updates, the preparation is also done in the
>> new_state but the cleanups are done in the new_state (because updates
>> are performed in place, i.e. in the current state).
>>
>> The current code blocks async udpates when the fb is changed, turning
>> async updates into sync updates, slowing down cursor updates and
>> introducing regressions in igt tests with errors of type:
>>
>> "CRITICAL: completed 97 cursor updated in a period of 30 flips, we
>> expect to complete approximately 15360 updates, with the threshold set
>> at 7680"
>>
>> Fb changes in async updates were prevented to avoid the following scenario:
>>
>> - Async update, oldfb = NULL, newfb = fb1, prepare fb1, cleanup fb1
>> - Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb2
>> - Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2 (wrong)
>> Where we have a single call to prepare fb2 but double cleanup call to fb2.
>>
>> To solve the above problems, instead of blocking async fb changes, we
>> place the old framebuffer in the new_state object, so when the code
>> performs cleanups in the new_state it will cleanup the old_fb and we
>> will have the following scenario instead:
>>
>> - Async update, oldfb = NULL, newfb = fb1, prepare fb1, no cleanup
>> - Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb1
>> - Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2
>>
>> Where calls to prepare/cleanup are balanced.
>>
>> Cc: <stable@vger.kernel.org> # v4.14+
> 
> I'm not convinced this should be cc: stable, seems more in the improvement
> category than a bug fix.

I'm cc'ing to stable because the commit mentioned below inserted a
regression regarding the speed that cursors can be updated.

> 
>> Fixes: 25dc194b34dd ("drm: Block fb changes for async plane updates")
>> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>>
>> ---
>> Hello,
>>
>> I added a TODO in drm_atomic_helper_async_commit() regarding doing a
>> full state swap(), Boris and Nicholas, let me know if this is ok and if
>> I can keep your Reviewed-by tags)
>>
>> As mentioned in the cover letter, I tested in almost all platforms with
>> igt plane_cursor_legacy and kms_cursor_legacy and I didn't see any
>> regressions. But I couldn't test on MSM and AMD because I don't have
>> the hardware I would appreciate if anyone could help me testing those.
>>
>> Thanks!
>> Helen
>>
>> Changes in v3:
>> - Add Reviewed-by tags
>> - Add TODO in drm_atomic_helper_async_commit()
>>
>> Changes in v2:
>> - Change the order of the patch in the series, add this as the last one.
>> - Add documentation
>> - s/ballanced/balanced
>>
>>  drivers/gpu/drm/drm_atomic_helper.c      | 22 ++++++++++++----------
>>  include/drm/drm_modeset_helper_vtables.h |  5 +++++
>>  2 files changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
>> index 2453678d1186..de5812c362b5 100644
>> --- a/drivers/gpu/drm/drm_atomic_helper.c
>> +++ b/drivers/gpu/drm/drm_atomic_helper.c
>> @@ -1608,15 +1608,6 @@ int drm_atomic_helper_async_check(struct drm_device *dev,
>>  	    old_plane_state->crtc != new_plane_state->crtc)
>>  		return -EINVAL;
>>  
>> -	/*
>> -	 * FIXME: Since prepare_fb and cleanup_fb are always called on
>> -	 * the new_plane_state for async updates we need to block framebuffer
>> -	 * changes. This prevents use of a fb that's been cleaned up and
>> -	 * double cleanups from occuring.
>> -	 */
>> -	if (old_plane_state->fb != new_plane_state->fb)
>> -		return -EINVAL;
>> -
>>  	funcs = plane->helper_private;
>>  	if (!funcs->atomic_async_update)
>>  		return -EINVAL;
>> @@ -1647,6 +1638,8 @@ EXPORT_SYMBOL(drm_atomic_helper_async_check);
>>   * drm_atomic_async_check() succeeds. Async commits are not supposed to swap
>>   * the states like normal sync commits, but just do in-place changes on the
>>   * current state.
>> + *
>> + * TODO: Implement full swap instead of doing in-place changes.
>>   */
>>  void drm_atomic_helper_async_commit(struct drm_device *dev,
>>  				    struct drm_atomic_state *state)
>> @@ -1657,6 +1650,9 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
>>  	int i;
>>  
>>  	for_each_new_plane_in_state(state, plane, plane_state, i) {
>> +		struct drm_framebuffer *new_fb = plane_state->fb;
>> +		struct drm_framebuffer *old_fb = plane->state->fb;
>> +
>>  		funcs = plane->helper_private;
>>  		funcs->atomic_async_update(plane, plane_state);
>>  
>> @@ -1665,11 +1661,17 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
>>  		 * plane->state in-place, make sure at least common
>>  		 * properties have been properly updated.
>>  		 */
>> -		WARN_ON_ONCE(plane->state->fb != plane_state->fb);
>> +		WARN_ON_ONCE(plane->state->fb != new_fb);
>>  		WARN_ON_ONCE(plane->state->crtc_x != plane_state->crtc_x);
>>  		WARN_ON_ONCE(plane->state->crtc_y != plane_state->crtc_y);
>>  		WARN_ON_ONCE(plane->state->src_x != plane_state->src_x);
>>  		WARN_ON_ONCE(plane->state->src_y != plane_state->src_y);
>> +
>> +		/*
>> +		 * Make sure the FBs have been swapped so that cleanups in the
>> +		 * new_state performs a cleanup in the old FB.
>> +		 */
>> +		WARN_ON_ONCE(plane_state->fb != old_fb);
>>  	}
>>  }
>>  EXPORT_SYMBOL(drm_atomic_helper_async_commit);
>> diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
>> index cfb7be40bed7..ce582e8e8f2f 100644
>> --- a/include/drm/drm_modeset_helper_vtables.h
>> +++ b/include/drm/drm_modeset_helper_vtables.h
>> @@ -1174,6 +1174,11 @@ struct drm_plane_helper_funcs {
>>  	 * current one with the new plane configurations in the new
>>  	 * plane_state.
>>  	 *
>> +	 * Drivers should also swap the framebuffers between plane state
> 
> Perhaps add "current" before plane state and then after add "(&drm_plane.state)"
> so it's more clear what you're referring to here?
> 
>> +	 * and new_state. This is required because prepare and cleanup calls
>> +	 * are performed on the new_state object, then to cleanup the old
>> +	 * framebuffer, it needs to be placed inside the new_state object.
> 
> I'd change this bit to:
> 
>         * This is required since cleanup for async commits is performed on
>         * the new state, rather than old state like for traditional commits.
>         * Since we want to give up the reference on the current (old) fb instead
>         * of our brand new one, swap them in the driver during the async commit.
> 
>> +	 *
>>  	 * FIXME:
>>  	 *  - It only works for single plane updates
>>  	 *  - Async Pageflips are not supported yet
>> -- 
>> 2.20.1
>>
> 

Thanks, I'm sending this update in v4.

Helen
