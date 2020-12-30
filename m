Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04182E7A4F
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgL3P2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgL3P2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 10:28:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8391C207A6;
        Wed, 30 Dec 2020 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609342074;
        bh=nQ1bE0XU5XKYrOhnsCQRuEHMlA+lFxTJXWr24jV7rU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0A/AIZ4V5a5B82DrCxaCB9AN/jjXIpLZCgmDobQbftbUYBH72PJRezvBmY4uhDUMU
         KLy2OEPU1wrEWsi9uz6mti8hihdVbXO1ePRE7Eqlxzu4EKChisAZN4CgptznUDtVQR
         hCMav4/6KhbhaU4pEO+jRD/LCKT3RzPYgQYn4MqQ=
Date:   Wed, 30 Dec 2020 16:29:20 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "bp@alien8.de" <bp@alien8.de>, "bp@suse.de" <bp@suse.de>,
        "Huang, ChiaWen" <ChiaWen.Huang@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: Add get_dig_frontend
 implementation for DCEx" failed to apply to 5.10-stable tree
Message-ID: <X+yc0ORyMxcJ5x6y@kroah.com>
References: <16091523531566@kroah.com>
 <MN2PR12MB4488C7584D074C9C2E85262CF7D80@MN2PR12MB4488.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4488C7584D074C9C2E85262CF7D80@MN2PR12MB4488.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 04:06:42PM +0000, Deucher, Alexander wrote:
> [AMD Public Use]
> 
> Please use the attached backported patch instead for 5.10.  Thanks!

Now applied, thanks.

greg k-h
