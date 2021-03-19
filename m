Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6A0341B3F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 12:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCSLQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 07:16:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:27894 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhCSLQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 07:16:14 -0400
IronPort-SDR: t60MtGMyKdGQLSXB/vkbKQdF2E+9az34WLhdBlR9LAvOm1FbrkpCr37bd62VqsQQ04+99B4hRc
 +MB7/5oLMbqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189912146"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="189912146"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 04:16:12 -0700
IronPort-SDR: bv+TO+QmJn/kspUkm9oeLq4G3YIb9wclOHgZmdYwU1cYKcOG4YvJh8x3JJj0QkSi6VQJh5sPln
 Erf4/4d6bRvw==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="606573486"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 04:16:09 -0700
Date:   Fri, 19 Mar 2021 13:16:06 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Takashi Iwai <tiwai@suse.de>, Bodo Graumann <mail@bodograumann.de>,
        Santiago Zarate <santiago.zarate@suse.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Lakshminarayana Vudum <lakshminarayana.vudum@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: =?utf-8?B?4pyTIEZpLkNJLklHVDogc3VjY2Vz?=
 =?utf-8?Q?s_for_drm=2Fi915?= =?utf-8?Q?=3A?= Fix DP LTTPR link training mode
 initialization (rev2)
Message-ID: <20210319111606.GD94006@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210317184901.4029798-1-imre.deak@intel.com>
 <161602046432.17366.7917891017821188755@emeril.freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161602046432.17366.7917891017821188755@emeril.freedesktop.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 10:34:24PM +0000, Patchwork wrote:
> == Series Details ==
> 
> Series: drm/i915: Fix DP LTTPR link training mode initialization (rev2)
> URL   : https://patchwork.freedesktop.org/series/88070/
> State : success

Patchset pushed to drm-intel-next, thanks for the reports, testing and review.

I'll send a separate backport to the 5.11 stable tree if needed, since
patch 1 will not apply there due to a trivial conflict (intel_dp.c ->
intel_dp_aux.c code movement in drm-intel-next).

> 
> == Summary ==
> 
> CI Bug Log - changes from CI_DRM_9866_full -> Patchwork_19802_full
> ====================================================
> 
> Summary
> -------
> 
>   **SUCCESS**
> 
>   No regressions found.
> 
>   
> 
> Known issues
> ------------
> 
>   Here are the changes found in Patchwork_19802_full that come from known issues:
> 
> ### IGT changes ###
> 
> #### Issues hit ####
> 
>   * igt@gem_create@create-massive:
>     - shard-snb:          NOTRUN -> [DMESG-WARN][1] ([i915#3002])
>    [1]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb7/igt@gem_create@create-massive.html
> 
>   * igt@gem_ctx_isolation@preservation-s3@vcs0:
>     - shard-apl:          [PASS][2] -> [DMESG-WARN][3] ([i915#180]) +1 similar issue
>    [2]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-apl8/igt@gem_ctx_isolation@preservation-s3@vcs0.html
>    [3]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl3/igt@gem_ctx_isolation@preservation-s3@vcs0.html
> 
>   * igt@gem_ctx_persistence@legacy-engines-hang@blt:
>     - shard-skl:          NOTRUN -> [SKIP][4] ([fdo#109271]) +159 similar issues
>    [4]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl9/igt@gem_ctx_persistence@legacy-engines-hang@blt.html
> 
>   * igt@gem_ctx_persistence@legacy-engines-mixed:
>     - shard-snb:          NOTRUN -> [SKIP][5] ([fdo#109271] / [i915#1099]) +5 similar issues
>    [5]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb7/igt@gem_ctx_persistence@legacy-engines-mixed.html
> 
>   * igt@gem_exec_fair@basic-flow@rcs0:
>     - shard-tglb:         [PASS][6] -> [FAIL][7] ([i915#2842])
>    [6]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-tglb1/igt@gem_exec_fair@basic-flow@rcs0.html
>    [7]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-tglb2/igt@gem_exec_fair@basic-flow@rcs0.html
> 
>   * igt@gem_exec_fair@basic-none@rcs0:
>     - shard-glk:          [PASS][8] -> [FAIL][9] ([i915#2842])
>    [8]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-glk5/igt@gem_exec_fair@basic-none@rcs0.html
>    [9]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-glk7/igt@gem_exec_fair@basic-none@rcs0.html
> 
>   * igt@gem_exec_fair@basic-pace@vcs0:
>     - shard-kbl:          [PASS][10] -> [FAIL][11] ([i915#2842])
>    [10]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl6/igt@gem_exec_fair@basic-pace@vcs0.html
>    [11]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl2/igt@gem_exec_fair@basic-pace@vcs0.html
> 
>   * igt@gem_exec_fair@basic-pace@vcs1:
>     - shard-iclb:         NOTRUN -> [FAIL][12] ([i915#2842])
>    [12]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb1/igt@gem_exec_fair@basic-pace@vcs1.html
> 
>   * igt@gem_exec_reloc@basic-many-active@rcs0:
>     - shard-snb:          NOTRUN -> [FAIL][13] ([i915#2389]) +2 similar issues
>    [13]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb7/igt@gem_exec_reloc@basic-many-active@rcs0.html
> 
>   * igt@gem_exec_schedule@u-fairslice@rcs0:
>     - shard-skl:          [PASS][14] -> [DMESG-WARN][15] ([i915#1610] / [i915#2803])
>    [14]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl9/igt@gem_exec_schedule@u-fairslice@rcs0.html
>    [15]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@gem_exec_schedule@u-fairslice@rcs0.html
> 
>   * igt@gem_huc_copy@huc-copy:
>     - shard-kbl:          NOTRUN -> [SKIP][16] ([fdo#109271] / [i915#2190])
>    [16]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@gem_huc_copy@huc-copy.html
> 
>   * igt@gem_mmap_gtt@cpuset-medium-copy-odd:
>     - shard-iclb:         [PASS][17] -> [FAIL][18] ([i915#307]) +1 similar issue
>    [17]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb5/igt@gem_mmap_gtt@cpuset-medium-copy-odd.html
>    [18]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb1/igt@gem_mmap_gtt@cpuset-medium-copy-odd.html
> 
>   * igt@gem_pwrite@basic-exhaustion:
>     - shard-skl:          NOTRUN -> [WARN][19] ([i915#2658])
>    [19]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl6/igt@gem_pwrite@basic-exhaustion.html
>     - shard-snb:          NOTRUN -> [WARN][20] ([i915#2658])
>    [20]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb2/igt@gem_pwrite@basic-exhaustion.html
>     - shard-apl:          NOTRUN -> [WARN][21] ([i915#2658])
>    [21]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl2/igt@gem_pwrite@basic-exhaustion.html
> 
>   * igt@gem_userptr_blits@process-exit-mmap@wb:
>     - shard-apl:          NOTRUN -> [SKIP][22] ([fdo#109271] / [i915#1699]) +7 similar issues
>    [22]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl2/igt@gem_userptr_blits@process-exit-mmap@wb.html
>     - shard-skl:          NOTRUN -> [SKIP][23] ([fdo#109271] / [i915#1699]) +3 similar issues
>    [23]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl6/igt@gem_userptr_blits@process-exit-mmap@wb.html
> 
>   * igt@gem_vm_create@destroy-race:
>     - shard-tglb:         [PASS][24] -> [TIMEOUT][25] ([i915#2795])
>    [24]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-tglb8/igt@gem_vm_create@destroy-race.html
>    [25]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-tglb5/igt@gem_vm_create@destroy-race.html
> 
>   * igt@gen9_exec_parse@allowed-single:
>     - shard-skl:          [PASS][26] -> [DMESG-WARN][27] ([i915#1436] / [i915#716])
>    [26]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl7/igt@gen9_exec_parse@allowed-single.html
>    [27]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl9/igt@gen9_exec_parse@allowed-single.html
> 
>   * igt@gen9_exec_parse@bb-chained:
>     - shard-iclb:         NOTRUN -> [SKIP][28] ([fdo#112306])
>    [28]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@gen9_exec_parse@bb-chained.html
> 
>   * igt@i915_module_load@reload-with-fault-injection:
>     - shard-skl:          NOTRUN -> [DMESG-WARN][29] ([i915#1982])
>    [29]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl4/igt@i915_module_load@reload-with-fault-injection.html
> 
>   * igt@i915_pm_dc@dc6-dpms:
>     - shard-kbl:          NOTRUN -> [FAIL][30] ([i915#454])
>    [30]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl6/igt@i915_pm_dc@dc6-dpms.html
> 
>   * igt@i915_pm_dc@dc6-psr:
>     - shard-skl:          NOTRUN -> [FAIL][31] ([i915#454])
>    [31]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@i915_pm_dc@dc6-psr.html
> 
>   * igt@i915_pm_lpsp@kms-lpsp@kms-lpsp-dp:
>     - shard-apl:          NOTRUN -> [SKIP][32] ([fdo#109271] / [i915#1937])
>    [32]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl2/igt@i915_pm_lpsp@kms-lpsp@kms-lpsp-dp.html
> 
>   * igt@i915_pm_rc6_residency@rc6-idle:
>     - shard-iclb:         NOTRUN -> [WARN][33] ([i915#1804] / [i915#2684])
>    [33]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@i915_pm_rc6_residency@rc6-idle.html
> 
>   * igt@i915_query@query-topology-unsupported:
>     - shard-iclb:         NOTRUN -> [SKIP][34] ([fdo#109302])
>    [34]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@i915_query@query-topology-unsupported.html
> 
>   * igt@i915_selftest@live@hangcheck:
>     - shard-snb:          NOTRUN -> [INCOMPLETE][35] ([i915#2782])
>    [35]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb6/igt@i915_selftest@live@hangcheck.html
> 
>   * igt@kms_big_fb@yf-tiled-8bpp-rotate-270:
>     - shard-iclb:         NOTRUN -> [SKIP][36] ([fdo#110723])
>    [36]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_big_fb@yf-tiled-8bpp-rotate-270.html
> 
>   * igt@kms_big_joiner@invalid-modeset:
>     - shard-skl:          NOTRUN -> [SKIP][37] ([fdo#109271] / [i915#2705])
>    [37]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl10/igt@kms_big_joiner@invalid-modeset.html
>     - shard-kbl:          NOTRUN -> [SKIP][38] ([fdo#109271] / [i915#2705])
>    [38]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl2/igt@kms_big_joiner@invalid-modeset.html
> 
>   * igt@kms_ccs@pipe-c-crc-primary-rotation-180:
>     - shard-skl:          NOTRUN -> [SKIP][39] ([fdo#109271] / [fdo#111304])
>    [39]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl10/igt@kms_ccs@pipe-c-crc-primary-rotation-180.html
> 
>   * igt@kms_chamelium@vga-hpd:
>     - shard-apl:          NOTRUN -> [SKIP][40] ([fdo#109271] / [fdo#111827]) +19 similar issues
>    [40]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl6/igt@kms_chamelium@vga-hpd.html
> 
>   * igt@kms_chamelium@vga-hpd-after-suspend:
>     - shard-skl:          NOTRUN -> [SKIP][41] ([fdo#109271] / [fdo#111827]) +15 similar issues
>    [41]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_chamelium@vga-hpd-after-suspend.html
> 
>   * igt@kms_color@pipe-a-ctm-0-25:
>     - shard-iclb:         NOTRUN -> [FAIL][42] ([i915#1149] / [i915#315])
>    [42]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_color@pipe-a-ctm-0-25.html
> 
>   * igt@kms_color@pipe-b-ctm-0-75:
>     - shard-skl:          [PASS][43] -> [DMESG-WARN][44] ([i915#1982])
>    [43]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl4/igt@kms_color@pipe-b-ctm-0-75.html
>    [44]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl5/igt@kms_color@pipe-b-ctm-0-75.html
> 
>   * igt@kms_color_chamelium@pipe-a-ctm-blue-to-red:
>     - shard-kbl:          NOTRUN -> [SKIP][45] ([fdo#109271] / [fdo#111827]) +7 similar issues
>    [45]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl6/igt@kms_color_chamelium@pipe-a-ctm-blue-to-red.html
>     - shard-iclb:         NOTRUN -> [SKIP][46] ([fdo#109284] / [fdo#111827]) +4 similar issues
>    [46]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_color_chamelium@pipe-a-ctm-blue-to-red.html
> 
>   * igt@kms_color_chamelium@pipe-c-ctm-red-to-blue:
>     - shard-snb:          NOTRUN -> [SKIP][47] ([fdo#109271] / [fdo#111827]) +24 similar issues
>    [47]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb7/igt@kms_color_chamelium@pipe-c-ctm-red-to-blue.html
> 
>   * igt@kms_color_chamelium@pipe-d-ctm-blue-to-red:
>     - shard-iclb:         NOTRUN -> [SKIP][48] ([fdo#109278] / [fdo#109284] / [fdo#111827]) +1 similar issue
>    [48]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@kms_color_chamelium@pipe-d-ctm-blue-to-red.html
> 
>   * igt@kms_content_protection@dp-mst-type-1:
>     - shard-iclb:         NOTRUN -> [SKIP][49] ([i915#3116])
>    [49]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@kms_content_protection@dp-mst-type-1.html
> 
>   * igt@kms_content_protection@srm:
>     - shard-apl:          NOTRUN -> [TIMEOUT][50] ([i915#1319])
>    [50]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl7/igt@kms_content_protection@srm.html
> 
>   * igt@kms_cursor_crc@pipe-a-cursor-suspend:
>     - shard-skl:          [PASS][51] -> [INCOMPLETE][52] ([i915#300])
>    [51]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl4/igt@kms_cursor_crc@pipe-a-cursor-suspend.html
>    [52]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl4/igt@kms_cursor_crc@pipe-a-cursor-suspend.html
> 
>   * igt@kms_cursor_crc@pipe-b-cursor-512x512-rapid-movement:
>     - shard-iclb:         NOTRUN -> [SKIP][53] ([fdo#109278] / [fdo#109279])
>    [53]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@kms_cursor_crc@pipe-b-cursor-512x512-rapid-movement.html
> 
>   * igt@kms_cursor_crc@pipe-d-cursor-256x256-rapid-movement:
>     - shard-iclb:         NOTRUN -> [SKIP][54] ([fdo#109278]) +4 similar issues
>    [54]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_cursor_crc@pipe-d-cursor-256x256-rapid-movement.html
> 
>   * igt@kms_cursor_legacy@2x-nonblocking-modeset-vs-cursor-atomic:
>     - shard-iclb:         NOTRUN -> [SKIP][55] ([fdo#109274] / [fdo#109278])
>    [55]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@kms_cursor_legacy@2x-nonblocking-modeset-vs-cursor-atomic.html
> 
>   * igt@kms_cursor_legacy@flip-vs-cursor-atomic-transitions-varying-size:
>     - shard-skl:          NOTRUN -> [FAIL][56] ([i915#2346] / [i915#533])
>    [56]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl10/igt@kms_cursor_legacy@flip-vs-cursor-atomic-transitions-varying-size.html
> 
>   * igt@kms_cursor_legacy@flip-vs-cursor-busy-crc-atomic:
>     - shard-apl:          NOTRUN -> [DMESG-FAIL][57] ([IGT#6])
>    [57]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl8/igt@kms_cursor_legacy@flip-vs-cursor-busy-crc-atomic.html
> 
>   * igt@kms_flip@flip-vs-expired-vblank-interruptible@a-edp1:
>     - shard-skl:          NOTRUN -> [FAIL][58] ([i915#79])
>    [58]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl9/igt@kms_flip@flip-vs-expired-vblank-interruptible@a-edp1.html
> 
>   * igt@kms_flip@flip-vs-expired-vblank@a-edp1:
>     - shard-skl:          [PASS][59] -> [FAIL][60] ([i915#79])
>    [59]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl5/igt@kms_flip@flip-vs-expired-vblank@a-edp1.html
>    [60]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl3/igt@kms_flip@flip-vs-expired-vblank@a-edp1.html
> 
>   * igt@kms_flip@flip-vs-expired-vblank@c-hdmi-a2:
>     - shard-glk:          [PASS][61] -> [FAIL][62] ([i915#79]) +2 similar issues
>    [61]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-glk4/igt@kms_flip@flip-vs-expired-vblank@c-hdmi-a2.html
>    [62]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-glk5/igt@kms_flip@flip-vs-expired-vblank@c-hdmi-a2.html
> 
>   * igt@kms_flip@flip-vs-suspend-interruptible@a-dp1:
>     - shard-kbl:          [PASS][63] -> [DMESG-WARN][64] ([i915#180]) +5 similar issues
>    [63]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl2/igt@kms_flip@flip-vs-suspend-interruptible@a-dp1.html
>    [64]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@kms_flip@flip-vs-suspend-interruptible@a-dp1.html
> 
>   * igt@kms_flip@flip-vs-suspend@c-dp1:
>     - shard-apl:          NOTRUN -> [DMESG-WARN][65] ([i915#180]) +1 similar issue
>    [65]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl2/igt@kms_flip@flip-vs-suspend@c-dp1.html
> 
>   * igt@kms_flip@plain-flip-fb-recreate@b-edp1:
>     - shard-skl:          NOTRUN -> [FAIL][66] ([i915#2122])
>    [66]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_flip@plain-flip-fb-recreate@b-edp1.html
> 
>   * igt@kms_flip@plain-flip-ts-check-interruptible@a-edp1:
>     - shard-skl:          [PASS][67] -> [FAIL][68] ([i915#2122])
>    [67]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl5/igt@kms_flip@plain-flip-ts-check-interruptible@a-edp1.html
>    [68]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl8/igt@kms_flip@plain-flip-ts-check-interruptible@a-edp1.html
> 
>   * igt@kms_flip_scaled_crc@flip-32bpp-ytile-to-32bpp-ytilegen12rcccs:
>     - shard-skl:          NOTRUN -> [SKIP][69] ([fdo#109271] / [i915#2672])
>    [69]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl9/igt@kms_flip_scaled_crc@flip-32bpp-ytile-to-32bpp-ytilegen12rcccs.html
>     - shard-apl:          NOTRUN -> [SKIP][70] ([fdo#109271] / [i915#2672]) +1 similar issue
>    [70]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl6/igt@kms_flip_scaled_crc@flip-32bpp-ytile-to-32bpp-ytilegen12rcccs.html
> 
>   * igt@kms_flip_scaled_crc@flip-32bpp-ytile-to-64bpp-ytile:
>     - shard-skl:          NOTRUN -> [SKIP][71] ([fdo#109271] / [i915#2642])
>    [71]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_flip_scaled_crc@flip-32bpp-ytile-to-64bpp-ytile.html
> 
>   * igt@kms_flip_scaled_crc@flip-32bpp-ytileccs-to-64bpp-ytile:
>     - shard-kbl:          NOTRUN -> [SKIP][72] ([fdo#109271] / [i915#2642])
>    [72]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@kms_flip_scaled_crc@flip-32bpp-ytileccs-to-64bpp-ytile.html
> 
>   * igt@kms_frontbuffer_tracking@fbcpsr-2p-primscrn-spr-indfb-draw-mmap-cpu:
>     - shard-iclb:         NOTRUN -> [SKIP][73] ([fdo#109280]) +9 similar issues
>    [73]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@kms_frontbuffer_tracking@fbcpsr-2p-primscrn-spr-indfb-draw-mmap-cpu.html
> 
>   * igt@kms_frontbuffer_tracking@psr-1p-offscren-pri-shrfb-draw-blt:
>     - shard-skl:          [PASS][74] -> [FAIL][75] ([i915#49])
>    [74]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl8/igt@kms_frontbuffer_tracking@psr-1p-offscren-pri-shrfb-draw-blt.html
>    [75]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl9/igt@kms_frontbuffer_tracking@psr-1p-offscren-pri-shrfb-draw-blt.html
> 
>   * igt@kms_frontbuffer_tracking@psr-1p-primscrn-cur-indfb-onoff:
>     - shard-snb:          NOTRUN -> [SKIP][76] ([fdo#109271]) +421 similar issues
>    [76]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-snb7/igt@kms_frontbuffer_tracking@psr-1p-primscrn-cur-indfb-onoff.html
> 
>   * igt@kms_frontbuffer_tracking@psr-rgb101010-draw-mmap-wc:
>     - shard-kbl:          NOTRUN -> [SKIP][77] ([fdo#109271]) +61 similar issues
>    [77]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@kms_frontbuffer_tracking@psr-rgb101010-draw-mmap-wc.html
> 
>   * igt@kms_hdr@bpc-switch-dpms:
>     - shard-skl:          [PASS][78] -> [FAIL][79] ([i915#1188])
>    [78]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl9/igt@kms_hdr@bpc-switch-dpms.html
>    [79]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl4/igt@kms_hdr@bpc-switch-dpms.html
> 
>   * igt@kms_hdr@static-swap:
>     - shard-iclb:         NOTRUN -> [SKIP][80] ([i915#1187])
>    [80]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_hdr@static-swap.html
> 
>   * igt@kms_pipe_crc_basic@nonblocking-crc-pipe-d-frame-sequence:
>     - shard-skl:          NOTRUN -> [SKIP][81] ([fdo#109271] / [i915#533]) +1 similar issue
>    [81]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_pipe_crc_basic@nonblocking-crc-pipe-d-frame-sequence.html
> 
>   * igt@kms_pipe_crc_basic@read-crc-pipe-d:
>     - shard-apl:          NOTRUN -> [SKIP][82] ([fdo#109271] / [i915#533]) +1 similar issue
>    [82]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl7/igt@kms_pipe_crc_basic@read-crc-pipe-d.html
> 
>   * igt@kms_plane@plane-panning-bottom-right-suspend-pipe-a-planes:
>     - shard-skl:          [PASS][83] -> [FAIL][84] ([i915#1036] / [i915#533])
>    [83]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl8/igt@kms_plane@plane-panning-bottom-right-suspend-pipe-a-planes.html
>    [84]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl9/igt@kms_plane@plane-panning-bottom-right-suspend-pipe-a-planes.html
> 
>   * igt@kms_plane_alpha_blend@pipe-a-alpha-7efc:
>     - shard-kbl:          NOTRUN -> [FAIL][85] ([fdo#108145] / [i915#265])
>    [85]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@kms_plane_alpha_blend@pipe-a-alpha-7efc.html
> 
>   * igt@kms_plane_alpha_blend@pipe-a-alpha-basic:
>     - shard-apl:          NOTRUN -> [FAIL][86] ([fdo#108145] / [i915#265]) +2 similar issues
>    [86]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl8/igt@kms_plane_alpha_blend@pipe-a-alpha-basic.html
> 
>   * igt@kms_plane_alpha_blend@pipe-c-alpha-opaque-fb:
>     - shard-skl:          NOTRUN -> [FAIL][87] ([fdo#108145] / [i915#265]) +4 similar issues
>    [87]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_plane_alpha_blend@pipe-c-alpha-opaque-fb.html
> 
>   * igt@kms_plane_alpha_blend@pipe-c-alpha-transparent-fb:
>     - shard-apl:          NOTRUN -> [FAIL][88] ([i915#265])
>    [88]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl8/igt@kms_plane_alpha_blend@pipe-c-alpha-transparent-fb.html
> 
>   * igt@kms_plane_alpha_blend@pipe-c-coverage-7efc:
>     - shard-skl:          [PASS][89] -> [FAIL][90] ([fdo#108145] / [i915#265])
>    [89]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl1/igt@kms_plane_alpha_blend@pipe-c-coverage-7efc.html
>    [90]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_plane_alpha_blend@pipe-c-coverage-7efc.html
> 
>   * igt@kms_psr2_sf@overlay-plane-update-sf-dmg-area-1:
>     - shard-skl:          NOTRUN -> [SKIP][91] ([fdo#109271] / [i915#658]) +1 similar issue
>    [91]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl10/igt@kms_psr2_sf@overlay-plane-update-sf-dmg-area-1.html
> 
>   * igt@kms_psr2_sf@overlay-plane-update-sf-dmg-area-3:
>     - shard-kbl:          NOTRUN -> [SKIP][92] ([fdo#109271] / [i915#658]) +2 similar issues
>    [92]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@kms_psr2_sf@overlay-plane-update-sf-dmg-area-3.html
> 
>   * igt@kms_psr2_sf@overlay-plane-update-sf-dmg-area-5:
>     - shard-iclb:         NOTRUN -> [SKIP][93] ([i915#658]) +1 similar issue
>    [93]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_psr2_sf@overlay-plane-update-sf-dmg-area-5.html
> 
>   * igt@kms_psr2_sf@overlay-primary-update-sf-dmg-area-4:
>     - shard-apl:          NOTRUN -> [SKIP][94] ([fdo#109271] / [i915#658]) +7 similar issues
>    [94]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl8/igt@kms_psr2_sf@overlay-primary-update-sf-dmg-area-4.html
> 
>   * igt@kms_psr@psr2_cursor_plane_onoff:
>     - shard-iclb:         [PASS][95] -> [SKIP][96] ([fdo#109441])
>    [95]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb2/igt@kms_psr@psr2_cursor_plane_onoff.html
>    [96]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@kms_psr@psr2_cursor_plane_onoff.html
> 
>   * igt@kms_psr@psr2_primary_mmap_cpu:
>     - shard-iclb:         NOTRUN -> [SKIP][97] ([fdo#109441]) +1 similar issue
>    [97]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@kms_psr@psr2_primary_mmap_cpu.html
> 
>   * igt@kms_sysfs_edid_timing:
>     - shard-skl:          NOTRUN -> [FAIL][98] ([IGT#2])
>    [98]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@kms_sysfs_edid_timing.html
> 
>   * igt@kms_vblank@pipe-d-wait-forked-hang:
>     - shard-apl:          NOTRUN -> [SKIP][99] ([fdo#109271]) +203 similar issues
>    [99]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl2/igt@kms_vblank@pipe-d-wait-forked-hang.html
> 
>   * igt@kms_writeback@writeback-fb-id:
>     - shard-apl:          NOTRUN -> [SKIP][100] ([fdo#109271] / [i915#2437]) +1 similar issue
>    [100]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-apl8/igt@kms_writeback@writeback-fb-id.html
> 
>   * igt@nouveau_crc@pipe-a-ctx-flip-skip-current-frame:
>     - shard-iclb:         NOTRUN -> [SKIP][101] ([i915#2530])
>    [101]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@nouveau_crc@pipe-a-ctx-flip-skip-current-frame.html
> 
>   * igt@perf@gen12-mi-rpc:
>     - shard-iclb:         NOTRUN -> [SKIP][102] ([fdo#109289])
>    [102]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@perf@gen12-mi-rpc.html
> 
>   * igt@perf@polling-parameterized:
>     - shard-kbl:          [PASS][103] -> [FAIL][104] ([i915#1542])
>    [103]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl3/igt@perf@polling-parameterized.html
>    [104]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl4/igt@perf@polling-parameterized.html
> 
>   * igt@sysfs_clients@recycle:
>     - shard-kbl:          [PASS][105] -> [FAIL][106] ([i915#3028])
>    [105]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl3/igt@sysfs_clients@recycle.html
>    [106]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl6/igt@sysfs_clients@recycle.html
> 
>   
> #### Possible fixes ####
> 
>   * igt@gem_create@create-clear:
>     - shard-glk:          [FAIL][107] ([i915#3160]) -> [PASS][108]
>    [107]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-glk6/igt@gem_create@create-clear.html
>    [108]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-glk2/igt@gem_create@create-clear.html
> 
>   * igt@gem_ctx_persistence@many-contexts:
>     - shard-iclb:         [INCOMPLETE][109] ([i915#3057]) -> [PASS][110]
>    [109]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb6/igt@gem_ctx_persistence@many-contexts.html
>    [110]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb8/igt@gem_ctx_persistence@many-contexts.html
> 
>   * igt@gem_eio@in-flight-contexts-10ms:
>     - shard-tglb:         [TIMEOUT][111] ([i915#3063]) -> [PASS][112]
>    [111]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-tglb3/igt@gem_eio@in-flight-contexts-10ms.html
>    [112]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-tglb8/igt@gem_eio@in-flight-contexts-10ms.html
>     - shard-iclb:         [TIMEOUT][113] -> [PASS][114]
>    [113]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb7/igt@gem_eio@in-flight-contexts-10ms.html
>    [114]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb1/igt@gem_eio@in-flight-contexts-10ms.html
> 
>   * igt@gem_exec_fair@basic-none@vcs0:
>     - shard-kbl:          [FAIL][115] ([i915#2842]) -> [PASS][116] +1 similar issue
>    [115]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl2/igt@gem_exec_fair@basic-none@vcs0.html
>    [116]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@gem_exec_fair@basic-none@vcs0.html
> 
>   * igt@gem_exec_fair@basic-pace-share@rcs0:
>     - shard-glk:          [FAIL][117] ([i915#2842]) -> [PASS][118]
>    [117]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-glk9/igt@gem_exec_fair@basic-pace-share@rcs0.html
>    [118]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-glk8/igt@gem_exec_fair@basic-pace-share@rcs0.html
> 
>   * igt@gem_exec_fair@basic-pace@rcs0:
>     - shard-kbl:          [SKIP][119] ([fdo#109271]) -> [PASS][120]
>    [119]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl6/igt@gem_exec_fair@basic-pace@rcs0.html
>    [120]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl2/igt@gem_exec_fair@basic-pace@rcs0.html
> 
>   * igt@gem_exec_schedule@u-fairslice@rcs0:
>     - shard-iclb:         [DMESG-WARN][121] ([i915#2803]) -> [PASS][122]
>    [121]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb4/igt@gem_exec_schedule@u-fairslice@rcs0.html
>    [122]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb7/igt@gem_exec_schedule@u-fairslice@rcs0.html
> 
>   * igt@gem_exec_schedule@u-fairslice@vecs0:
>     - shard-skl:          [DMESG-WARN][123] ([i915#1610] / [i915#2803]) -> [PASS][124]
>    [123]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl9/igt@gem_exec_schedule@u-fairslice@vecs0.html
>    [124]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl7/igt@gem_exec_schedule@u-fairslice@vecs0.html
> 
>   * igt@i915_suspend@debugfs-reader:
>     - shard-skl:          [INCOMPLETE][125] ([i915#198]) -> [PASS][126] +1 similar issue
>    [125]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl2/igt@i915_suspend@debugfs-reader.html
>    [126]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl8/igt@i915_suspend@debugfs-reader.html
> 
>   * igt@kms_color@pipe-c-ctm-0-75:
>     - shard-skl:          [DMESG-WARN][127] ([i915#1982]) -> [PASS][128]
>    [127]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl8/igt@kms_color@pipe-c-ctm-0-75.html
>    [128]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl6/igt@kms_color@pipe-c-ctm-0-75.html
> 
>   * igt@kms_flip@flip-vs-expired-vblank@c-edp1:
>     - shard-tglb:         [FAIL][129] ([i915#79]) -> [PASS][130]
>    [129]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-tglb3/igt@kms_flip@flip-vs-expired-vblank@c-edp1.html
>    [130]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-tglb5/igt@kms_flip@flip-vs-expired-vblank@c-edp1.html
> 
>   * igt@kms_flip@plain-flip-ts-check-interruptible@a-hdmi-a1:
>     - shard-glk:          [FAIL][131] ([i915#2122]) -> [PASS][132]
>    [131]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-glk5/igt@kms_flip@plain-flip-ts-check-interruptible@a-hdmi-a1.html
>    [132]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-glk1/igt@kms_flip@plain-flip-ts-check-interruptible@a-hdmi-a1.html
> 
>   * igt@kms_frontbuffer_tracking@psr-1p-primscrn-spr-indfb-draw-mmap-gtt:
>     - shard-skl:          [FAIL][133] ([i915#49]) -> [PASS][134]
>    [133]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-skl8/igt@kms_frontbuffer_tracking@psr-1p-primscrn-spr-indfb-draw-mmap-gtt.html
>    [134]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-skl10/igt@kms_frontbuffer_tracking@psr-1p-primscrn-spr-indfb-draw-mmap-gtt.html
> 
>   * igt@kms_hdr@bpc-switch-suspend:
>     - shard-kbl:          [DMESG-WARN][135] ([i915#180]) -> [PASS][136] +3 similar issues
>    [135]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-kbl7/igt@kms_hdr@bpc-switch-suspend.html
>    [136]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-kbl7/igt@kms_hdr@bpc-switch-suspend.html
> 
>   * igt@kms_psr@psr2_sprite_plane_move:
>     - shard-iclb:         [SKIP][137] ([fdo#109441]) -> [PASS][138] +2 similar issues
>    [137]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb3/igt@kms_psr@psr2_sprite_plane_move.html
>    [138]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb2/igt@kms_psr@psr2_sprite_plane_move.html
> 
>   * igt@sysfs_clients@recycle:
>     - shard-iclb:         [FAIL][139] ([i915#3028]) -> [PASS][140]
>    [139]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-iclb6/igt@sysfs_clients@recycle.html
>    [140]: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/shard-iclb6/igt@sysfs_clients@recycle.html
> 
>   * igt@sysfs_clients@recycle-many:
>     - shard-tglb:         [FAIL][141] ([i915#3028]) -> [PASS][142] +1 similar issue
>    [141]: https://intel-gfx-ci.01.org/tree/drm-tip/CI_DRM_9866/shard-tglb7/ig
> 
> == Logs ==
> 
> For more details see: https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_19802/index.html
