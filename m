Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4565E2D79AF
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392648AbgLKPoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:44:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:26085 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390648AbgLKPn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:43:57 -0500
IronPort-SDR: jDDsCdwTJdmLxXFKw8BMZS+10WCBLwT3GkjoqRR2XIKibx88TzpjP1hoNW0Dg89045G18LYCBQ
 NiXLMGK7pFtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="238557330"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="238557330"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 07:42:10 -0800
IronPort-SDR: 8GcczHJRgPBSbn8VAs1UX0mK6shOPulvVbZXGtRkUx2zpw+u2LOGZr/EjJIldtVope8EorfnUR
 SifaBcA/1b3Q==
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="349521183"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.249.144.44]) ([10.249.144.44])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 07:42:07 -0800
Subject: Re: [PATCH] ASoC: Intel: Skylake: Check the kcontrol against NULL
To:     Lukasz Majczak <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mateusz Gorski <mateusz.gorski@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, Guenter Roeck <groeck@google.com>,
        Radoslaw Biernacki <rad@semihalf.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Alex Levin <levinale@google.com>
References: <20201210121438.7718-1-lma@semihalf.com>
From:   =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
Message-ID: <669da93a-2ef2-fa08-6c7f-be2e6b5ac363@linux.intel.com>
Date:   Fri, 11 Dec 2020 16:42:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201210121438.7718-1-lma@semihalf.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/2020 1:14 PM, Lukasz Majczak wrote:
> +		kcontrol = dobj->control.kcontrol;
> +		if(!kcontrol)
> +			continue;

Small nitpick, there should be space between if and opening parenthesis 
as recommended by coding style.

Thanks,
Amadeusz
