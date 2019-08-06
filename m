Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744BD83AC0
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfHFVDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfHFVDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:03:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F9220C01;
        Tue,  6 Aug 2019 21:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565125416;
        bh=eI2HKR7RuxJ9kMRo2bqq2lLDUxkhAB9oqvxEZuJmUWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2fKD0kxcYW9RsVwyrR/wIS9hyvvaAxs7HQ2a/stUIR+218LHAwNNxQ4cGXtpde5s
         xCpLHap5ALxccIQRc/jKfS0dYGS516VsjdrMw9vu9jR5A6Tr5lvnioudfL1sR43mqP
         SZ82fOVMMXrgbYt8+sGC7SIzj5weTPQjYmx24zQ8=
Date:   Tue, 6 Aug 2019 17:03:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo
Message-ID: <20190806210335.GI17747@sasha-vm>
References: <CAHCN7xLyZAxK2L0+bjT9a+aZXtjmCtTRP9kC2Org9=R1rwf8yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHCN7xLyZAxK2L0+bjT9a+aZXtjmCtTRP9kC2Org9=R1rwf8yg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 09:56:27AM -0500, Adam Ford wrote:
>Please apply a135a392acbec7ecda782981788e8c03767a1571 ("ARM: dts: Add
>pinmuxing for i2c2 and i2c3 for LogicPD torpedo") to 4.9.y branch.
>
>Ideally, it would be applied to 4.4, but It doesn't apply cleanly to
>4.4.  I can do a separate patch to do that, but I am not sure of the
>proper procedure.
>
>Due to some changes in the bootloader, I2C2 and 3 may not necessarily
>be muxed properly.  This patch will ensure it's working for the
>various devices connected to it.

Applied to 4.14 and 4.9, if this needs to go to 4.4 then please send a
backport.

--
Thanks,
Sasha
