Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE51521C506
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 18:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGKQHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jul 2020 12:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgGKQHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jul 2020 12:07:18 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E65282075F;
        Sat, 11 Jul 2020 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594483638;
        bh=QJiRbjhCIeONXQ32+undZ60c46h62ysZp7BHELes3gE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1rlZF6o3fXC8nCMjVktbgNs6nL0IrjatxLIXtYknsJCLUc/9MIo3IlKXLj3wzWV37
         zq2PCSbIz+oMgEzK0LWPy1xiaDE8brA8D9iw3TlfM9fSm3xrwudZ4kdAmg/P/o2Asd
         5xOCvBGD0bJNR66ZTv+dkkp0S8BUiQ2f+FZGfePA=
Date:   Sat, 11 Jul 2020 12:07:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] kallsyms: Refactor kallsyms_show_value() to take cred
Message-ID: <20200711160716.GF2722994@sasha-vm>
References: <20200702232638.2946421-2-keescook@chromium.org>
 <20200710140307.911FB2082E@mail.kernel.org>
 <202007100857.EEB63BE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202007100857.EEB63BE@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 08:57:32AM -0700, Kees Cook wrote:
>On Fri, Jul 10, 2020 at 02:03:06PM +0000, Sasha Levin wrote:
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: all
>>
>> The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.
>
>Was this test for only 1/5, or the whole series?

Just 1/5.

-- 
Thanks,
Sasha
