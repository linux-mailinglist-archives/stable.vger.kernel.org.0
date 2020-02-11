Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25F1587F0
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 02:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgBKB0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 20:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbgBKB0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 20:26:39 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31D2920838;
        Tue, 11 Feb 2020 01:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581384399;
        bh=JlPKEIh8RKhZFMW+vF9rWMVYIXjVmrqJTbfUL5mEP9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vr9VNxazm24qUHGqVBrH/OWrxtdiY2b4SMPh7p1aRN97ZH4kIEBRNM6i83/IxiR6p
         yToBZKo3Hhu36GmZuzg2XAIgS1cyiton68lceguxmIT7d8wft9iHfMzWn3hefTW/Pm
         FIY52odExs2o/o/um/ZtbLGxQok89gq8wMpVyP5A=
Date:   Mon, 10 Feb 2020 20:26:38 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Amol Grover <frextrite@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: Re: [PATCH 5.5 150/367] tracing: Annotate ftrace_graph_hash pointer
 with __rcu
Message-ID: <20200211012638.GB13097@sasha-vm>
References: <20200210122423.695146547@linuxfoundation.org>
 <20200210122438.674498788@linuxfoundation.org>
 <CAEXW_YSPDHcuLiM4B8uXvw-0ei2Gj0x=QE1h+NMqzRiBph1oNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEXW_YSPDHcuLiM4B8uXvw-0ei2Gj0x=QE1h+NMqzRiBph1oNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 10, 2020 at 06:36:20AM -0800, Joel Fernandes wrote:
>On Mon, Feb 10, 2020 at 4:40 AM Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> From: Amol Grover <frextrite@gmail.com>
>>
>> [ Upstream commit 24a9729f831462b1d9d61dc85ecc91c59037243f ]
>
>Amol, can you send a follow-up patch to annotate
>ftrace_graph_notrace_hash as well?

Note that I took this to make later stable tagged patch apply cleanly. I
don't expect these annotation changes to be picked up for stable on
their own.

-- 
Thanks,
Sasha
