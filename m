Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30CF87F1
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 06:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725298AbfKLFcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 00:32:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfKLFcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 00:32:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD5D52084F;
        Tue, 12 Nov 2019 05:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573536732;
        bh=D1HFtAvc3hCzBmU0QvlcXIBLWwLxCeMYDj6FzzOAeWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GAxKTfCgt+yN2+Y1bWS+XbwhfNVlwBzGDUBIE9iRZwprM7ZpBaD++/aOWFlebylYL
         /LiQ9/Vqu2DgT/GUGjg++lxmvQB0wrPQdyJVorpsy1sQijqkZMlmluVaVmM9kw9EuE
         cD+F5F+1CTbPGy9qGf5NVPxVNZtY65a5Z1ZQQUO0=
Date:   Tue, 12 Nov 2019 06:10:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "kernelci.org bot" <bot@kernelci.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/105] 4.14.154-stable review
Message-ID: <20191112051035.GA1160399@kroah.com>
References: <20191111181421.390326245@linuxfoundation.org>
 <5dca16a0.1c69fb81.35eb7.dbb1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dca16a0.1c69fb81.35eb7.dbb1@mx.google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 06:19:12PM -0800, kernelci.org bot wrote:
> stable-rc/linux-4.14.y boot: 112 boots: 104 failed, 0 passed with 8 offline (v4.14.153-106-ga46a2b6a665b)

wow, everything dies :(

