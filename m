Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2A43D6213
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhGZPeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:34:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:47218 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234050AbhGZPdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:33:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10057"; a="209157983"
X-IronPort-AV: E=Sophos;i="5.84,270,1620716400"; 
   d="scan'208";a="209157983"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 09:13:32 -0700
X-IronPort-AV: E=Sophos;i="5.84,270,1620716400"; 
   d="scan'208";a="455815068"
Received: from jwconner-mobl1.amr.corp.intel.com (HELO [10.209.169.36]) ([10.209.169.36])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 09:13:31 -0700
Subject: Re: FAILED: patch "[PATCH] ASoC: Intel: boards: fix xrun issue on
 platform with max98373" failed to apply to 5.13-stable tree
To:     gregkh@linuxfoundation.org, rander.wang@intel.com,
        bard.liao@intel.com, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com
Cc:     stable@vger.kernel.org
References: <162729704572242@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <28e1efbe-b06b-abe0-1987-275442340926@linux.intel.com>
Date:   Mon, 26 Jul 2021 11:13:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162729704572242@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/26/21 5:57 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.13-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Indeed there is an additional rename which causes a conflict, we'll
resend a patch that applies cleanly.

This is only needed for 5.12+ btw.
