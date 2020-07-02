Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B682120D0
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 12:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgGBKPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 06:15:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:60762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgGBKO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 06:14:28 -0400
IronPort-SDR: Gnxj7rRa6tQar97LsVvft+1/iCuYwjoEZI2Acbs91yMliherdsWr/i2scRn0MkAX75PC3X+w71
 B+8FE5W4Ly8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126467984"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126467984"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 03:14:26 -0700
IronPort-SDR: ctd/vJ6pf8QOJ8RP6O4ccGGcR/+wfiLyKoX55+3K6/UGxMdWKLDXrBieJqQM5YWyMU7SUP5j6l
 qpbLbBr327iA==
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="455475917"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 03:14:25 -0700
Date:   Thu, 2 Jul 2020 13:14:00 +0300 (EEST)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     stable@vger.kernel.org
cc:     =?ISO-8859-15?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: drm/i915: use forced codec wake on all gen9+ platforms
Message-ID: <alpine.DEB.2.22.394.2007021302030.3186@eliteleevi.tm.intel.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-318106570-1786057578-1593684843=:3186"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---318106570-1786057578-1593684843=:3186
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hey,

following commit from 5.8-rc1 would be beneficial for 5.4+ kernels.
We've verified it fixes audio driver probe errors on systems with Intel 
gen10/11/12 display hardware:
    Link: https://github.com/thesofproject/linux/issues/1847

commit 1c664c15cf0a31784b217a84fa0128ce46f17a84
Author: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Date:   Tue Mar 24 17:32:12 2020 +0200

    drm/i915: use forced codec wake on all gen9+ platforms
    
    Commit 632f3ab95fe2 ("drm/i915/audio: add codec wakeup override
    enabled/disable callback"), added logic to toggle Codec Wake on gen9.
    This is used by audio driver when it resets the HDA controller.
    
    It seems explicit toggling of the wakeline can help to fix problems
    with probe failing on some gen12 platforms. And based on specs, there
    is no reason why this programming sequence should not be applied to 
all
    gen9+ platforms. No side-effects are seen on gen10/11. So apply
    the wake-logic to all gen9+ platforms.
    
    Link: https://github.com/thesofproject/linux/issues/1847
    Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
    Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
    Link: https://patchwork.freedesktop.org/patch/msgid/20200324153212.6303-1-kai.vehmanen@linux.intel.com

Br, Kai

---318106570-1786057578-1593684843=:3186--
