Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD873DB387
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbhG3G12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhG3G11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 02:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22FD760F94;
        Fri, 30 Jul 2021 06:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627626442;
        bh=I6HqvJJHRnryIg/IN1aSUDpCHoCX1eGAla3wotJdjWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NNNeVkjgL61UxNGHE0AfMDra4d7nRIV/HNCc2c+dImQqh6f48tJQbmv3mzV+OGTDh
         AsHHVGno5rU/xnu8hSI57Sw87rSCOOYYMLcDG1NA7KRimCYjJRFHWHLsjFfpw5cDpW
         8cYBAlgZ+SP2cR5T62FiHse6Y8fX4zAQ8nznHL9Y=
Date:   Fri, 30 Jul 2021 08:27:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9
Message-ID: <YQObyFN/7K1bJ43Z@kroah.com>
References: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 03:08:03PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> This is a patch series to CVE-2021-21781.

Given that this looks to be a "private" CVE at this point in time:
	https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-21781
you are going to have to provide a bit more information here :(

thanks,

greg k-h
