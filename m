Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795A0116889
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfLIIqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:46:31 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9540 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfLIIqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 03:46:30 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dee09e00000>; Mon, 09 Dec 2019 00:46:24 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 09 Dec 2019 00:46:30 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 09 Dec 2019 00:46:30 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec
 2019 08:46:28 +0000
Received: from [10.26.11.118] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec 2019
 08:46:26 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     Trond Myklebust <trondmy@hammerspace.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: stable request: 5.4.y: SUNRPC: Avoid RPC delays when exiting suspend
Message-ID: <370ef599-8164-170c-8ba0-f8a9082578c4@nvidia.com>
Date:   Mon, 9 Dec 2019 08:46:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575881184; bh=vPfpH4Ay0TA7NhdK1p/zLSLRILTBDa4Qtn4NYXmNOQw=;
        h=X-PGP-Universal:To:CC:From:Subject:Message-ID:Date:User-Agent:
         MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
         Content-Language:Content-Transfer-Encoding;
        b=dSceNNFuxqev0mbRkG2foQSEhv8uY2k09Cij0v2zPTOkASQqhNf2fopyhcDTnuiTW
         1XskeNFPQWgDrmgDvCAEETWFqzX/QZ/wJHKtsCBV9u07SeBrn3KCW415RQSvt/hzDs
         HTrPMVIkyfKm6p1AK5JWHkwsHXxHch0A+hIpOfC7xCFflB6JfVeaF2bzQ8sOt5cZSW
         oMsveGT7Q0LhaIMsIpvCcRwE2QpgNl2y2J7pjUFjwnk6967yuXHsedL136+8BjITgl
         OONlODumeHGHDwq9mnxLuE1QnPa4OT6m1anAJ4nHNethxWxSptS8uRtgsKVDO+xemw
         QE6whImpe3Nww==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please can you include the following for 5.4.y. This fixes long delays
exiting suspend when using NFS and was causing one of our suspend tests
to fail.

commit 66eb3add452aa1be65ad536da99fac4b8f620b74
Author: Trond Myklebust <trond.myklebust@hammerspace.com>
Date:   Tue Nov 5 09:10:54 2019 -0500

    SUNRPC: Avoid RPC delays when exiting suspend


Thanks
Jon

-- 
nvpublic
