Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8C19970B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgCaNLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730905AbgCaNLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:24 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF8720786;
        Tue, 31 Mar 2020 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660283;
        bh=1xtFAKXGm+X1qtcHwxiBg5ZrZy/4PYKqBeAGcz/qET8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=tXt4LeGnhP9krLmXqluqzBjodEfN0liFBtRkGaWgfGtdS6tS00UKfambIvVTpYSOl
         gnvaWY65JfvQyzfwLxheA5TPNtdFYVBxiwFCGMcmaXAdqEHu7qcZBv4n3Csnu8QGd4
         XkhOKUzJvsOln2QhyzBgwdHipWaG+LuRUlaQx/qE=
Date:   Tue, 31 Mar 2020 13:11:22 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-serial@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] serial: sh-sci: Make sure status register SCxSR is read in correct sequence
In-Reply-To: <1585333048-31828-1-git-send-email-kazuhiro.fujita.jg@renesas.com>
References: <1585333048-31828-1-git-send-email-kazuhiro.fujita.jg@renesas.com>
Message-Id: <20200331131123.2CF8720786@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174, v4.9.217, v4.4.217.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Build OK!
v4.14.174: Build OK!
v4.9.217: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.217: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
