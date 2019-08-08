Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C40685A23
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 07:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbfHHF5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 01:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfHHF5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 01:57:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D0C2186A;
        Thu,  8 Aug 2019 05:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565243858;
        bh=DEz2PWPlcjM+jBxzINtFbgeHlUl8AtxVjUlI8gJDO8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O1ouUUOBFV5C9jfeUIGqJsdusRMMNEMsylG7EEH8iZpa0S8HIcX/8bI2yd4a43Lhb
         q5af9IcNHR7pQtzejfyhXgTPW32mK3fZfEn3HneYVWwKFCTf3lYI1WUQQRmRYnVJI4
         ZN9bsZ82CU0Uce+fQf/J49LkVVLoFbH3ftBbKrvs=
Date:   Thu, 8 Aug 2019 07:57:36 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Souza, Jose" <jose.souza@intel.com>
Cc:     "Nikula, Jani" <jani.nikula@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "kubrick@fgv6.net" <kubrick@fgv6.net>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>
Subject: Re: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
Message-ID: <20190808055736.GA24953@kroah.com>
References: <156498469082135@kroah.com>
 <20190805224951.6523-1-jose.souza@intel.com>
 <87mugmkaam.fsf@intel.com>
 <a9fb603fdbeeaf41c90ad5a793e1da0473a532cb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9fb603fdbeeaf41c90ad5a793e1da0473a532cb.camel@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 07:37:13PM +0000, Souza, Jose wrote:
> Hi Greg
> 
> Anything is missing to have this merged for 5.2.8?

Patience :)

The queue is long and you only sent this 2 days ago...

