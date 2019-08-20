Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528329662E
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfHTQVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfHTQVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 12:21:44 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1A722DD3;
        Tue, 20 Aug 2019 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318103;
        bh=gy2kDZ6tfN/m/15KjEgcPJKm1xDXwtTc8PXPT5qDCO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pg9YkvyjPddudYOngXgOSqwAKmCBDydvRNAXO1IRDlRQIob4NWJkD8UrTaCH/Y+33
         7ND069dbWTEscHvytdOurYiJIhAx5uw+RAb0ED3XjDVzTHa4fQuvDkPcNnL+dn48Bx
         upSy691Jt6+ic20rHMwsR7jYT01UOg/o8VCTwNX0=
Date:   Tue, 20 Aug 2019 09:21:43 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wan.fahim.asqalanix.wan.yusof@intel.com
Cc:     stable@vger.kernel.org, jose.souza@intel.com,
        tong.liang.chew@intel.com, jui.nee.tan@intel.com
Subject: Re: [PATCH] drm/i915/cfl: Add a new CFL PCI ID.
Message-ID: <20190820162143.GA8214@kroah.com>
References: <1566270859-20963-1-git-send-email-wan.fahim.asqalanix.wan.yusof@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1566270859-20963-1-git-send-email-wan.fahim.asqalanix.wan.yusof@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 11:14:19AM +0800, wan.fahim.asqalanix.wan.yusof@intel.com wrote:
> From: Rodrigo Vivi <rodrigo.vivi@intel.com>
> 
> commit d0e062ebb3a44b56a7e672da568334c76f763552 upstream
> 
> One more CFL ID added to spec.
> 
> Cc: stable@vger.kernel.org
> Cc: José Roberto de Souza <jose.souza@intel.com>
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20180803232721.20038-1-rodrigo.vivi@intel.com
> (cherry picked from commit d0e062ebb3a44b56a7e672da568334c76f763552)
> Signed-off-by: Wan Yusof, Wan Fahim AsqalaniX <wan.fahim.asqalanix.wan.yusof@intel.com>
> ---
>  include/drm/i915_pciids.h | 1 +
>  1 file changed, 1 insertion(+)

Now queued up, thanks.

greg k-h
