Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D169114F85
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 11:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfLFKzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 05:55:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19421 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfLFKzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 05:55:22 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dea33950000>; Fri, 06 Dec 2019 02:55:17 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 06 Dec 2019 02:55:21 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 06 Dec 2019 02:55:21 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec
 2019 10:55:21 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Dec 2019
 10:55:19 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: stable request: 5.4.y: arm64: tegra: Fix 'active-low' warning for
 Jetson
Message-ID: <16724779-0514-ca92-58b2-95f4e244c6f7@nvidia.com>
Date:   Fri, 6 Dec 2019 10:55:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575629717; bh=zP+fzvHokKpy7hHAQMG6fY8LVKKSduwhCUebOjD4AYU=;
        h=X-PGP-Universal:To:CC:From:Subject:Message-ID:Date:User-Agent:
         MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Language:Content-Transfer-Encoding;
        b=WgyjOhjVohkiOtR6k9LV/GxWZpoHyFzXCZAA0mp2AokYfina7V3TLcgdFp7zyf7+j
         8EERvp98D60Ban5Tgj2MdTBp/CiE36tIj2hUvmYp4Oan5t+wXZ2EuBGAVfYYyFCKdy
         OW5GgyxyZL4ijx0L7GI6Tvd4CypwVPeRYJOawfaq0eVPjt7QSGW2PrW1nY5UyrMyzi
         IcYm5T5eeYkl6cb8SBm1xjxPIB0Bu2Re4dopA6Gjy/s/bkAnHPi2Lgi3cDFzRLpbSh
         PRk+vJdYPAaeIJa7WytZxJ3hn4Teh2dYmHpIx5BVOySisZYmQ6NHtQTNFavjnqsu5R
         9HTALb3zq0nWA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please can you include the following device-tree fixes for 5.4.y that
are triggering some warnings on a couple of our Jetson platforms. This
is currently causing one of our kernel warnings tests to fail. Both of
these have now been merged into the mainline for v5.5-rc1.

commit d440538e5f219900a9fc9d96fd10727b4d2b3c48
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Wed Sep 25 15:12:28 2019 +0100

    arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator

commit 1e5e929c009559bd7e898ac8e17a5d01037cb057
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Wed Sep 25 15:12:29 2019 +0100

    arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Thanks
Jon

-- 
nvpublic
