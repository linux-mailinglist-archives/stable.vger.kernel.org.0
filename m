Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333F7C8D96
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfJBQGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 12:06:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:43889 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfJBQGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 12:06:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 09:06:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="185597189"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 02 Oct 2019 09:06:15 -0700
Received: from abapat-mobl1.amr.corp.intel.com (unknown [10.251.1.101])
        by linux.intel.com (Postfix) with ESMTP id D54FE5803E4;
        Wed,  2 Oct 2019 09:06:14 -0700 (PDT)
Subject: Re: [alsa-devel] [PATCH 2/2] soundwire: depend on ACPI || OF
To:     Michal Suchanek <msuchanek@suse.de>, alsa-devel@alsa-project.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        Sanyog Kale <sanyog.r.kale@intel.com>
References: <20191002081717.GA4015@kitsune.suse.cz>
 <91e2fc425e0dea92d7f131da890e52af273de36c.1570005196.git.msuchanek@suse.de>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <c0b00292-2529-135d-8282-974684508396@linux.intel.com>
Date:   Wed, 2 Oct 2019 11:06:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <91e2fc425e0dea92d7f131da890e52af273de36c.1570005196.git.msuchanek@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/2/19 3:33 AM, Michal Suchanek wrote:
> Now devicetree is supposrted for probing sondwire as well.

typos...

also it'd be simpler to squash the two patches together and add in the 
commit message a mention that the s390 builds without ACPI and without OF.

> 
> Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>   drivers/soundwire/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/soundwire/Kconfig b/drivers/soundwire/Kconfig
> index c73bfbaa2659..c8c80df090d1 100644
> --- a/drivers/soundwire/Kconfig
> +++ b/drivers/soundwire/Kconfig
> @@ -5,7 +5,7 @@
>   
>   menuconfig SOUNDWIRE
>   	tristate "SoundWire support"
> -	depends on ACPI
> +	depends on ACPI || OF
>   	help
>   	  SoundWire is a 2-Pin interface with data and clock line ratified
>   	  by the MIPI Alliance. SoundWire is used for transporting data
> 

