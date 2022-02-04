Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB9E4A94C1
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 08:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiBDHvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 02:51:36 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14406 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiBDHvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 02:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643961095; x=1675497095;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OU69SPUa+l83Mu45cpLpffTedY3GSfdNyoABwXgUlNg=;
  b=pl1U6BmZtOqyrAnBR4sHmeEj69VA1YYTjb4FubcnCAoUtvWj2Gl602pH
   9O6aItV8rfGyG9B1/H8O7O/ams+zkPog0gteqL/tSvd6eMIffy/CVa+Hg
   CHxVSLQXdmyMP534eCNLNY+uS8OJzmERs1vLvGQvD0/lYvpyUQpB01nzj
   lQBmCg15mcxagaS2eAWmoKVSG1CBCINDS6E4Q5vuPWaYofmzF6Yg9XhTS
   RiCxu56cVou3+k2+y/gpwfc9qvV9REuZLBxBUNNDjlR2uBT/ejeACj+qx
   M+6NgALdNmv+ss9q215DMT1sZNUFgbF2iMwPeKw6TVziwL40KF9KccIoF
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,342,1635177600"; 
   d="scan'208";a="196962753"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 15:51:34 +0800
IronPort-SDR: IcrGRk9irg8Z2t0nGYlBk1gzTkTpfOCe+l8Elo5nQsDjhBw2KYRTaC5KlLp9s8QLXTakUCQqFX
 LMj5zTeUGR6BlvB8gJVAz+xvpsPULQ+7H1k8bL5oBhtVREdDya/0TukPpK0SZ4140heNw+AExo
 Maxhp9jwWdvQpu1/yghDRlj1ZcYPH5KtmZoJdh3SgYAa3CjVwuKxqigCt45NpH5MaoelDf1Upt
 icNQRqW/lYSbmRRAUCv2I5F5i6jnapvIIGBZn5NjviXK7DBxRbMLNEW16cgft/jmBhup3ie8TR
 L0M94EIcYCwicYzuM1rZDwfa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 23:23:30 -0800
IronPort-SDR: FKj3JoKqUWiBoTpSy+1BjT/5JTDsWU/8DKJvKZ/G7P2tpR8w5oODmIXfkfWKC9K/XI9xPSjVsX
 3v0omzN42taHv/ZmZK1vpTyghopyhS2iTw3aEkmnltQMttemZH0AFOBKwvUiJ9Q/qPJpqGeqs/
 bjbOpaM8WMLABS7pPrRnOEecYsUCeTCRXGUkUCRwzR6Qmq5R+PZ99QtdicEHWrd7vfULWIKnBX
 O80NnZNZ9TDYYXXhRGAfKZcWeE4FTbZnX0nGOgSSXnYgg1yG2AAHAYf9lrY0PXUGy62A2I0YNe
 EH0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 23:51:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JqnmQ6YnQz1SVp0
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 23:51:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643961094; x=1646553095; bh=OU69SPUa+l83Mu45cpLpffTedY3GSfdNyoA
        BwXgUlNg=; b=BeFR6wGozfxGiIYz7H5JPW0yIHI+Yih3kiyPkqNhy+cmU45ZnQ/
        udiK+7p4YfpxiUZDGreic9gS5LSjfi3/9PuOT+D9UZX/PUubWcBIVul6iyBfyDHy
        hgZsZ6c1l4opf381t+j1As2ULX5Ci/nx1BcRXVr/kwVVaYZ5d+Zto3M70HOfrFOj
        3nsba/r6eTMrk7qBUYrSn9MxxgtVPE9e7HB43sE5RyKMHJvJqknVzdgEVNc+H8rH
        i2vMTzxbwK5XcMQYUVujfwTzVRgiLL8lMj79KsJRe3fa0MaR0osArM5nonPOhyXX
        hdXgMh9YmTG0rsqc8tp3XMVJ8PPuR3QUimg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id m151xVkg3fQt for <stable@vger.kernel.org>;
        Thu,  3 Feb 2022 23:51:34 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JqnmQ0wfnz1Rwrw;
        Thu,  3 Feb 2022 23:51:33 -0800 (PST)
Message-ID: <edf57911-dd28-881f-f723-cabb3557dd43@opensource.wdc.com>
Date:   Fri, 4 Feb 2022 16:51:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ata: libata-core: Introduce ATA_HORKAGE_NO_LOG_DIR
 horkage
Content-Language: en-US
To:     Anton Lundin <glance@acc.umu.se>, linux-ide@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220203094135.2437143-1-glance@acc.umu.se>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220203094135.2437143-1-glance@acc.umu.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/22 18:41, Anton Lundin wrote:
> 06f6c4c6c3e8 ("ata: libata: add missing ata_identify_page_supported() calls")
> introduced additional calls to ata_identify_page_supported(), thus also
> adding indirectly accesses to the device log directory log page through
> ata_log_supported(). Reading this log page causes SATADOM-ML 3ME devices
> to lock up.
> 
> Introduce the horkage flag ATA_HORKAGE_NO_LOG_DIR to prevent accesses to
> the log directory in ata_log_supported() and add a blacklist entry
> with this flag for "SATADOM-ML 3ME" devices.
> 
> Fixes: 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Anton Lundin <glance@acc.umu.se>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Applied to for-5.17-fixes. Thanks !


-- 
Damien Le Moal
Western Digital Research
