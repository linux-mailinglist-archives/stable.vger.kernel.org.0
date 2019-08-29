Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D16BA1B6D
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfH2N2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 09:28:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:40772 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfH2N2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 09:28:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 06:28:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,443,1559545200"; 
   d="scan'208";a="197805405"
Received: from kuha.fi.intel.com ([10.237.72.53])
  by fmsmga001.fm.intel.com with SMTP; 29 Aug 2019 06:28:08 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 29 Aug 2019 16:28:07 +0300
Date:   Thu, 29 Aug 2019 16:28:07 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/2] software node: Fix use of potentially uninitialized
 variable
Message-ID: <20190829132807.GG5486@kuha.fi.intel.com>
References: <20190829132116.76120-1-heikki.krogerus@linux.intel.com>
 <20190829132116.76120-3-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829132116.76120-3-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 04:21:16PM +0300, Heikki Krogerus wrote:
> reported by smatch:
> drivers/base/swnode.c:71 software_node_to_swnode() error: uninitialized symbol 'swnode'.
> 
> Fixes: 80488a6b1d3c ("software node: Add support for static node descriptors")
> Cc: stable@vger.kernel.org

Sorry. That was not needed. I need to resend these.

I think I'll just squash these two patches together.

thanks,

-- 
heikki
