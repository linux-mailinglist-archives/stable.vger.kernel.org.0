Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D28253EC5
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgH0HPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:15:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:5671 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgH0HPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:15:31 -0400
IronPort-SDR: 35a89xmw2/zUbdVn6bqvbMxHewMwvfQsdWnfgvoDWklKNa3DKvyQwbctyHprr+XKbhTDK6xbfD
 aEoPgAQ32g/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="144112349"
X-IronPort-AV: E=Sophos;i="5.76,358,1592895600"; 
   d="scan'208";a="144112349"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 00:15:30 -0700
IronPort-SDR: Zpm+ya4u91Zk+HFTnzEsfMZuveriW7ix0fFcTT2Hv0fvJEotLVmqf+NbcQu3eYwsPY142coxyd
 IiJ2JnYxKqDQ==
X-IronPort-AV: E=Sophos;i="5.76,358,1592895600"; 
   d="scan'208";a="475094944"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 00:15:28 -0700
Date:   Thu, 27 Aug 2020 10:14:18 +0300 (EEST)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
cc:     alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        ranjani.sridharan@linux.intel.com,
        Rander Wang <rander.wang@linux.intel.com>,
        kuninori.morimoto.gx@renesas.com,
        pierre-louis.bossart@linux.intel.com,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] ASoC: intel/skl/hda - fix probe regression on systems
 without i915
In-Reply-To: <159542547442.19620.11983281044239009101.b4-ty@kernel.org>
Message-ID: <alpine.DEB.2.22.394.2008271002260.3186@eliteleevi.tm.intel.com>
References: <20200714132804.3638221-1-kai.vehmanen@linux.intel.com> <159542547442.19620.11983281044239009101.b4-ty@kernel.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

+stable

On Wed, 22 Jul 2020, Mark Brown wrote:
> Applied to
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next
[...]
> 
> [1/1] ASoC: intel/skl/hda - fix probe regression on systems without i915
>       commit: ffc6d45d96f07a32700cb6b7be2d3459e63c255a

please apply this to stable kernels as well. Without the patch, audio is 
broken with 5.8.x on many laptops (with Intel audio and non-Intel 
graphics). One more recent bug filed:
https://github.com/thesofproject/sof/issues/3345

This does _not_ affect 5.7.x and older, plus already fixed in 5.9-rc.

Br, Kai

