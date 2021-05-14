Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED77A380A16
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhENNFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 09:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231518AbhENNFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 09:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00ADE613B5;
        Fri, 14 May 2021 13:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620997469;
        bh=hrSgVsZqaRBcljBBqNyheSc8FOIB8bhn2v+R26pY0do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C9E8ZPN0XCkJyfjkn+NTGxiHrRCs+QgHfH3Nhgd4S8+LFU14eN5D6MdzufXrK4Ozu
         QPi5zdYOVim4TNd7zGJirTf8aDyp10SzV8j5RvAutfl+s/4Afml2bPn1I5ndVghBXu
         XV1avhSVcY6uLcEMdmD3DtTa+Vl9R18sb+3frWu7YF3kGITx5vwdVLxHylRDK1yNZI
         vbFEZ6IeI/2z/SQCO59xKJxwJUHnnnsuLyOX21xjKJBpi6XWRphLOuG4exYqLsBe9J
         eUtBwcuRLWzm+tXPakNwJnisb209yL165zqFxnFuC0dRDqA1ys810A0x0O6c9vPpu7
         hqmvq4JPEiXNQ==
Date:   Fri, 14 May 2021 09:04:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Ward <david.ward@gatech.edu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.12 090/116] ASoC: rt286: Generalize support for
 ALC3263 codec
Message-ID: <YJ51W9tR95hjW0vN@sashalap>
References: <20210505163125.3460440-1-sashal@kernel.org>
 <20210505163125.3460440-90-sashal@kernel.org>
 <55cb81cd-4eb9-049a-abf6-d4628ac8cb34@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <55cb81cd-4eb9-049a-abf6-d4628ac8cb34@gatech.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 12:34:29AM -0400, David Ward wrote:
>On 5/5/21 12:30 PM, Sasha Levin wrote:
>>From: David Ward <david.ward@gatech.edu>
>>
>>[ Upstream commit aa2f9c12821e6a4ba1df4fb34a3dbc6a2a1ee7fe ]
>>
>>The ALC3263 codec on the XPS 13 9343 is also found on the Latitude 13 7350
>>and Venue 11 Pro 7140. They require the same handling for the combo jack to
>>work with a headset: GPIO pin 6 must be set.
>>
>>The HDA driver always sets this pin on the ALC3263, which it distinguishes
>>by the codec vendor/device ID 0x10ec0288 and PCI subsystem vendor ID 0x1028
>>(Dell). The ASoC driver does not use PCI, so adapt this check to use DMI to
>>determine if Dell is the system vendor.
>
>For this patch to be useful, commit cd8499d5c03b ("ASoC: rt286: Make 
>RT286_SET_GPIO_* readable and writable") from the same series is 
>needed as well, which fixed the regmap config.
>
>(The same comment is true for all stable branches.)

I'll take it too, thanks!

-- 
Thanks,
Sasha
