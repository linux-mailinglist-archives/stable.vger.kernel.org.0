Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138AD2DDA1B
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 21:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgLQUcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 15:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgLQUcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 15:32:53 -0500
Date:   Thu, 17 Dec 2020 15:32:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608237132;
        bh=xfEp4RcreG8ECWgzyCacHAvrWYgUL0LSYbDLgTJwtWo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=imYFUbdP/Sv/FPCAs5eyh1yqfqpB4W+spjQRo8tnJLUqNPTX+Z6VTzfSRg86TKmGf
         bs61n6VbSeN01SDcxP/FSoTbLCIc4tLT5VXMTZbSjgRPKRShfQJ1XPinIQ/x4sdxn8
         rXjM0emhGA046i6SZwF4E32uFlk1WN4gprdvxtn8qtun7DazQcWgC+RcHHUzpRmajz
         ovTKiuwtEEqkWZ3eo/YTqwtMrH8yHyGtC0zsUCIQejGRKxePus/VYHFcUB+WKg6pKm
         ldCn2QpKPezKmsv0Wd6vXLggkn9aIZvNpLwJAlaKvX/EN5SLfQBcsrXSi+ZWI9Qjgn
         nCLVUOtWbtY8g==
From:   Sasha Levin <sashal@kernel.org>
To:     Young Hsieh <youngh@uber.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: Question for AMD patches
Message-ID: <20201217203211.GB643756@sasha-vm>
References: <1B44E762-F9F2-4E2B-BFEF-6F032BE8841E@uber.com>
 <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 18, 2020 at 04:05:45AM +0800, Young Hsieh wrote:
>Hello,
>
>This is Young Hsieh from Uber and currently I am in Uber infra team and in charge of server system design. Nice to e-meet you!  :)
>
>We are working on AMD Milan platform with Debian, and notice there are some patches for performance and security improvements, which are not implemented in LTS kernels (4.14/4.19/5.4) yet. On our side, we prefer to use the general LTS kernel release instead of a customized kernel, in case we will not align on major fixes down the road. So would like to know if there is any plan to backport these patches and if so, what is the timeline?  Thanks a lot again for any advice.

Easy: use 5.10. It's LTS and has all the patches you care about.

-- 
Thanks,
Sasha
