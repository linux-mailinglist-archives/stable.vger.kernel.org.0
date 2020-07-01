Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0493C2113D8
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgGATql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:46:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:48931 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGATql (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:46:41 -0400
IronPort-SDR: y6zt76ttF2o1v9ZhPmRDuh/fyvcIOVTUTBcsZKSb07LtH80DYsVA0pEN/LxzHh8L2qGP/qd6+J
 fUPugapFl/Kw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="211747569"
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="211747569"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 12:46:40 -0700
IronPort-SDR: qvtnx4bm3+4pxd36Ik9wvC7W1BPk5Cmx9bMDuTWRDCyrb2afNfWbRXGtGr+nuTmVFTt6rONibS
 SAxQpcWzktww==
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="266844800"
Received: from sawhitac-mobl.amr.corp.intel.com (HELO [10.254.111.76]) ([10.254.111.76])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 12:46:40 -0700
Subject: Re: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S
 2 channel
To:     Sasha Levin <sashal@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200628155231.71089-2-hdegoede@redhat.com>
 <20200701193320.C948B20870@mail.kernel.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <869046c6-030c-9243-784d-ecabdb774fa7@linux.intel.com>
Date:   Wed, 1 Jul 2020 14:46:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200701193320.C948B20870@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/1/20 2:33 PM, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.
> 
> v5.7.6: Build OK!
> v5.4.49: Failed to apply! Possible dependencies:
>      0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")

This patch is probably the missing dependency, but it's quite large and 
invasive.

if we wanted to apply this patch to stable versions < 5.7, we should 
replace all occurrences of

asoc_rtd_to_cpu(rtd, 0) by rtd->cpu_dai

and

asoc_rtd_to_codec(rtd, 0) by rtd->codec_dai


