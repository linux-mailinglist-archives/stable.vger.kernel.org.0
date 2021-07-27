Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD53D6DE0
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 07:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhG0FPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 01:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234905AbhG0FPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 01:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EF06610A1;
        Tue, 27 Jul 2021 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627362937;
        bh=q3l/5BEkNaspmyfGHx+Q6OIMUwZkSjH21lAF/DPKFo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SX3cpG92ZduzWObJNUVlTrefERHbIjU3kIUDMi+tDFRL1t4tdEg8vL/POu2oCSpVD
         zAEUlqBxtv8iVf2GKNR8lLukB8QCH4AFnfCIHGfH5LwZD/rH+YexFQqC1TKilVV6pE
         m0DAAQ3Z28l/8NdtpVhNKrBRV1BBFALdOlws63jU=
Date:   Tue, 27 Jul 2021 07:14:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] Revert "drm/i915/gem: Asynchronous cmdparser"
Message-ID: <YP+WQ4Ej2jyHjIeO@kroah.com>
References: <20210726231548.3511743-1-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726231548.3511743-1-jason@jlekstrand.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 06:15:48PM -0500, Jason Ekstrand wrote:
> commit 93b713304188844b8514074dc13ffd56d12235d3 upstream.  This version
> applies to the 5.10 tree.

I do not see that commit id in Linus's tree, are you sure it is correct?

greg k-h
