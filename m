Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5050EF50E7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfKHQTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfKHQTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 11:19:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7437321882;
        Fri,  8 Nov 2019 16:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573229963;
        bh=YjHpHJsnmN9ziKC+Zq9hh4CkmHDW9lUf5ZspIG4xLQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aQYIxtT2Exr1VMGcJ3Cj5YIj6M/DPbE7+DmfTjWCYFMrRc+QOmWn8S8w1gDOSrFIy
         +rPnrFLL0E+6PZk0uCayggoHP9A14oRF/jhBf4oQXfCDIBFuskY/TU8UBFVHe5/5dm
         5C/6czohcWFBZzQd8R27CMD0wfPQ4kb+tzds+PVU=
Date:   Fri, 8 Nov 2019 17:19:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sandipan Das <sandipan@linux.ibm.com>
Cc:     stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, desnesn@linux.ibm.com
Subject: Re: [PATCH stable 5.3 1/2] selftests/powerpc: Add test case for
 tlbie vs mtpidr ordering issue
Message-ID: <20191108161920.GG761587@kroah.com>
References: <20191017052454.6794-1-sandipan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017052454.6794-1-sandipan@linux.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 10:54:53AM +0530, Sandipan Das wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> 
> commit 93cad5f789951eaa27c3392b15294b4e51253944 upstream.
> 
> Cc: stable@vger.kernel.org # v5.3
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> [mpe: Some minor fixes to make it build]
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20190924035254.24612-4-aneesh.kumar@linux.ibm.com
> [sandipan: Backported to v5.3]
> Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
> ---
>  tools/testing/selftests/powerpc/mm/Makefile   |   2 +
>  .../testing/selftests/powerpc/mm/tlbie_test.c | 734 ++++++++++++++++++
>  2 files changed, 736 insertions(+)
>  create mode 100644 tools/testing/selftests/powerpc/mm/tlbie_test.c

Both queued up, thanks.

greg k-h
