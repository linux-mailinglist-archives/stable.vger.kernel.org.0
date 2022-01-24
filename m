Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23521498328
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiAXPKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:10:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55242 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbiAXPKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:10:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2D44CE1194;
        Mon, 24 Jan 2022 15:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0E0C340E1;
        Mon, 24 Jan 2022 15:10:31 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-arm-kernel@lists.infradead.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
Date:   Mon, 24 Jan 2022 15:10:29 +0000
Message-Id: <164303699846.16509.12781762905211026351.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <164301227374.1433152.12808232644267107415.stgit@devnote2>
References: <164301227374.1433152.12808232644267107415.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Jan 2022 17:17:54 +0900, Masami Hiramatsu wrote:
> Mark the start_backtrace() as notrace and NOKPROBE_SYMBOL
> because this function is called from ftrace and lockdep to
> get the caller address via return_address(). The lockdep
> is used in kprobes, it should also be NOKPROBE_SYMBOL.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
      https://git.kernel.org/arm64/c/1e0924bd0991

-- 
Catalin

