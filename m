Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DE91EFA10
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFEOKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFEOKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:54 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7DA0207F7;
        Fri,  5 Jun 2020 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366253;
        bh=oK+Qj8mHvFAm2bMXVswglffedUhRx+nN5H0hOs+aryk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=XfEfh4Ii/9+psa5Fj1cZKOsNQadZq4yFjgW10vODG3XC7CetFwoyK4PPQF2oHMAyi
         tDaUaIyU6xfRL4IBj3BiJida4XPmfsJ5oTYGgwFQKJSZ5qMaH3FQyubvZ+bYJWWxir
         EikZ60lQbWXK8rePxh7xPJSqmgH865UvM0n303L4=
Date:   Fri, 05 Jun 2020 14:10:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Postponed gadget registration to the udc class driver
In-Reply-To: <137e787bf7c7935bda3358c8f07230d3f4998fad.1590745119.git.hminas@synopsys.com>
References: <137e787bf7c7935bda3358c8f07230d3f4998fad.1590745119.git.hminas@synopsys.com>
Message-Id: <20200605141053.B7DA0207F7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 117777b2c3bb ("usb: dwc2: Move gadget probe function into platform code").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build failed! Errors:
    drivers/usb/dwc2/platform.c:515:4: error: label ‘error_init’ used but not defined

v5.4.43: Build failed! Errors:
    drivers/usb/dwc2/platform.c:515:4: error: label ‘error_init’ used but not defined

v4.19.125: Build failed! Errors:
    drivers/usb/dwc2/platform.c:500:4: error: label ‘error_init’ used but not defined

v4.14.182: Build failed! Errors:
    drivers/usb/dwc2/platform.c:460:4: error: label ‘error_init’ used but not defined

v4.9.225: Build failed! Errors:
    drivers/usb/dwc2/platform.c:669:4: error: label ‘error_init’ used but not defined

v4.4.225: Build failed! Errors:
    drivers/usb/dwc2/platform.c:460:4: error: label ‘error_init’ used but not defined


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
