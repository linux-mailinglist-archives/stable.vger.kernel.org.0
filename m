Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED89823D7
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfHERRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbfHERRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 13:17:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E2120880;
        Mon,  5 Aug 2019 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565025459;
        bh=2yuQ9UZ9WKb3pFZYzsjGYCPYd9aRaY5K2g7+noCoIzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUo44L6NhWAGRHTlmkrBGjI9SzB0EUjUCLfQ4vNaAxAYqGmLxmyUnmXwkPLGuFDXq
         WFitDjMBral/MzXIjCEVNW5s2J15qF+06Fnb3nKcombWPzJiOaBtUPfEuyUdwq+04h
         W20yDycOYYcYXKdGXTMHAqOwi54xGEZ7iuvgBmT8=
Date:   Mon, 5 Aug 2019 18:17:36 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     catalin.marinas@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: FAILED: patch "[PATCH] arm64: cpufeature: Fix feature comparison
 for" failed to apply to 4.9-stable tree
Message-ID: <20190805171735.rpfqg7mjhj7oaadf@willie-the-truck>
References: <156498316660175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156498316660175@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 07:32:46AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Backport posted to:

  https://lore.kernel.org/stable/20190805171355.19308-1-will@kernel.org/T/#t

Will
