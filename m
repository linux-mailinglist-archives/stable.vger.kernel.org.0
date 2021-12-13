Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29750471F47
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 03:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhLMCL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 21:11:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:6813 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhLMCL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Dec 2021 21:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639361517; x=1670897517;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=jJL5MVBY9oPCNTX1JPSPpaOc+27f5b5MXMTvK3vwx5k=;
  b=TbBOvUZXVcUrNqaMxgLbXr05UNRv05XjTyh/cwUbbildP3/9ZMK1gvq3
   nupGT6/dbtF4tD8wkwma5XeSbsZDqplj0UZpKpEV9MMMAEjVBWTw7LBLa
   1F+wW0ORPJPmoE6fcSGWlw/S6dRwHw5lw3ukRFWN4o9otjjyRS342UJes
   BHTIu+d9MmlRIt5unMh9mf2URRLthDl9Zz91Dh6JUnpNj3hOzOG6d7F5v
   0+AGh+fM0lmj1r/WFPOi4QuRwcmEdsIyCgQK682O6qBwMRIc3PG/Oqu4p
   oT19e2EYSSHFS8bzJ0EScwj9W8gGJNtk2ELUUbFT94Nf1t7xXhirHyTTp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237384055"
X-IronPort-AV: E=Sophos;i="5.88,201,1635231600"; 
   d="scan'208";a="237384055"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 18:11:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,201,1635231600"; 
   d="scan'208";a="517561797"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.159.50])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 18:11:54 -0800
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Cc:     <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH -V2] numa balancing: move some document to make it
 consistent with the code
References: <20211213020422.2580612-1-ying.huang@intel.com>
Date:   Mon, 13 Dec 2021 10:11:52 +0800
In-Reply-To: <20211213020422.2580612-1-ying.huang@intel.com> (Huang Ying's
        message of "Mon, 13 Dec 2021 10:04:22 +0800")
Message-ID: <877dc9w8wn.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Sorry for confusing, the subject prefix should be [PATCH -V3].

Best Regards,
Huang, Ying
