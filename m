Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1961220A8A
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgGOKwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 06:52:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:36532 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729010AbgGOKwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 06:52:44 -0400
IronPort-SDR: yYEu10HFBKje/BXsIzDhuJmU4xLIH9wYxid17KBenKAkBOU/GzxtiiCqDgKONpNYhgmSdJdpPd
 jzGOye9ix/XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="167238903"
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="167238903"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 03:52:43 -0700
IronPort-SDR: bBxRYqxkrcYDm6Kp9QuiPqpgOW8qQfhpOOxV5oIsa+igeu5+hXuG3/gDOBSnVWTp+b6hpJQ/jx
 vf9MOov2LukQ==
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="460025160"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 03:52:41 -0700
Date:   Wed, 15 Jul 2020 13:52:05 +0300 (EEST)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: [PATCH AUTOSEL 4.4 7/9] ALSA: hda/hdmi: fix failures at PCM open
 on Intel ICL and later
In-Reply-To: <20200714144024.4036118-7-sashal@kernel.org>
Message-ID: <alpine.DEB.2.22.394.2007151332320.3186@eliteleevi.tm.intel.com>
References: <20200714144024.4036118-1-sashal@kernel.org> <20200714144024.4036118-7-sashal@kernel.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, 14 Jul 2020, Sasha Levin wrote:

> From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> 
> [ Upstream commit 56275036d8185f92eceac7479d48b858ee3dab84 ]
> 
> When HDMI PCM devices are opened in a specific order, with at least one
> HDMI/DP receiver connected, ALSA PCM open fails to -EBUSY on the
> connected monitor, on recent Intel platforms (ICL/JSL and newer). While

we don't have Ice Lake hardware support in the HDA HDMI codec driver in 
any 4.x stable trees (only in 5.1+), so this patch will not help on those 
and can be dropped.

Br, Kai
