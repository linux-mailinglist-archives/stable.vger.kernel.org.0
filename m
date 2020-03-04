Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAD2179864
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 19:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgCDSu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 13:50:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:60659 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgCDSuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 13:50:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 10:50:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="229420960"
Received: from smhiray-mobl1.amr.corp.intel.com (HELO [10.252.140.1]) ([10.252.140.1])
  by orsmga007.jf.intel.com with ESMTP; 04 Mar 2020 10:50:54 -0800
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
To:     Mark Brown <broonie@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>,
        stable@vger.kernel.org
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
 <20200304154450.GB5646@sirena.org.uk>
 <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
 <20200304160916.GC5646@sirena.org.uk>
 <44cf4ff8-120f-79fd-8801-47807b03f912@linux.intel.com>
 <20200304181113.GE5646@sirena.org.uk>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <669e6e57-3a84-7cf5-398f-eefdd333fadb@linux.intel.com>
Date:   Wed, 4 Mar 2020 12:50:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304181113.GE5646@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> This thread is the first suggestion I've seen that this is any kind of
> bug fix.  There's no Fixes tag and the patch description itself sounds
> like it's adding a new feature to enable new functionality in userspace
> (autodetection by UCM) and it was posted as part of a series "ASoC: SOF:
> initial cleanup for DT and multi-client support" which again doesn't
> give any indication that this might be supposed to be a bug fix. 

the initial patch came from Jaroslav on 11/26, not from me. Quoting your 
own words:

"Since Pierre seems happy with it even if he didn't ack it explicitly
I'll guess I'll apply it.  If git can figure out applying it after the
merge window and it doesn't get negative reviews there's no need to
resend.  If it can't and it doesn't turn up in a bigger series before
then I'll let you know.
"

That patch was however not applied, that's the confusion I was referring 
to, and I included it in an SOF v2 series as agreed along with a rebase 
of the DT/multiclient support stuff to avoid conflicts between patchsets.





