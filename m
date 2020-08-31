Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E71B25735D
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 07:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgHaFms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 01:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgHaFms (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 01:42:48 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ABC920738;
        Mon, 31 Aug 2020 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598852568;
        bh=RWLLnTBjZmFx7OFdUedWw2l/fWNwHBTNM+A88c+k2y8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sAeLkitRyddAB9IApuMGcfVySFr9qnMvS+p9ivVqnvVxLJUTWGvm+JNJCVsMz3Tf7
         HiCczMTgbtV90vDv8ZgymJuwOcHquUqhVib1LAk04Cpwq6u0Kffe7N2qYPka2XwoLV
         etF6GND8Cnnv0ASad8TlIYDOFpzaF4n+mxUkl6RA=
Date:   Mon, 31 Aug 2020 13:42:41 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Chris Healy <cphealy@gmail.com>
Cc:     srinivas.kandagatla@linaro.org, robh+dt@kernel.org,
        gregkh@linuxfoundation.org, maitysanchayan@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch, festevam@gmail.com, stable@vger.kernel.org,
        andrew.smirnov@gmail.com
Subject: Re: [PATCH v4] dt-bindings: nvmem: Add syscon to Vybrid OCOTP driver
Message-ID: <20200831054240.GK4488@dragon>
References: <20200825030406.373623-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825030406.373623-1-cphealy@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 08:04:06PM -0700, Chris Healy wrote:
> From: Chris Healy <cphealy@gmail.com>
> 
> Add syscon compatibility with Vybrid OCOTP driver binding. This is
> required to access the UID.
> 
> Fixes: 623069946952 ("nvmem: Add DT binding documentation for Vybrid
> OCOTP driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Healy <cphealy@gmail.com>

Applied, thanks.
