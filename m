Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25DA12D022
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 13:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfL3M62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 07:58:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:52889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfL3M62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 07:58:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Dec 2019 04:58:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,375,1571727600"; 
   d="scan'208";a="221128271"
Received: from zeliteleevi.tm.intel.com ([10.237.55.130])
  by orsmga003.jf.intel.com with ESMTP; 30 Dec 2019 04:58:25 -0800
Date:   Mon, 30 Dec 2019 14:58:25 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@zeliteleevi
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 102/219] ALSA: hda/hdmi - implement mst_no_extra_pcms
 flag
In-Reply-To: <20191230113214.GB10304@amd>
Message-ID: <alpine.DEB.2.21.1912301453150.16459@zeliteleevi>
References: <20191229162508.458551679@linuxfoundation.org> <20191229162523.844585380@linuxfoundation.org> <20191230113214.GB10304@amd>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, 30 Dec 2019, Pavel Machek wrote:

> > From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> > 
> > [ Upstream commit 2a2edfbbfee47947dd05f5860c66c0e80ee5e09d ]
> > 
> > To support the DP-MST multiple streams via single connector feature,
> > the HDMI driver was extended with the concept of backup PCMs. See
> > commit 9152085defb6 ("ALSA: hda - add DP MST audio support").
[...]
> This variable is not ever set in this patch, nor is it set elsewhere
> in 4.19-stable. This means this patch is not suitable for stable.

ack on that. In upstream this flag is only used by SOF (sound/soc/sof)
currently, but SOF is not part of 4.19, so there are no users for this 
flag. Sorry for not catching this sooner.

Br, Kai
