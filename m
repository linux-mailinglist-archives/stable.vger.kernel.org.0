Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC0211859
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 13:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfEBLry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 07:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfEBLrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 07:47:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39D12081C;
        Thu,  2 May 2019 11:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556797673;
        bh=awQPB7LyG47gPem32vUmf18uAGFHweaMzjGFvlLX3cI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENBR8cVS6c7tI3SAXuSMu3FtlLrGVdge+cgBe6zOwjC2IefGV1kkA7mXWaW8cQDeP
         Y5FvccUwnj82yz7HhJxttKPwdeaUF06NEtbwgHCizRYcX1B8QA9/dtpOwMBmukid7H
         GaglM38g4d3oEFqlDcCrWg+SVn3MJKn3nzc8IVSI=
Date:   Thu, 2 May 2019 13:47:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 5.0-stable] drm/i915: Do not enable FEC without DSC
Message-ID: <20190502114751.GB24696@kroah.com>
References: <155652995323242@kroah.com>
 <20190430175054.21797-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190430175054.21797-1-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 08:50:54PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> commit 5aae7832d1b4ec614996ea0f4fafc4d9855ec0b0 upstream.

Thanks for the backport, now queued up.

greg k-h
