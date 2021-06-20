Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B47E3AE009
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 21:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhFTTe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 15:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhFTTey (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Jun 2021 15:34:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A7DF6100A;
        Sun, 20 Jun 2021 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624217561;
        bh=2fTTN0sFxMijdD7N6lwI1a0MLk0kRqx643S1e6GYmVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZE3Xs015sQCpmS9Qa10nyfgsk12nNpjfB6gLb+h2+8UuZNe0lgFt5w4jURIdqJhp8
         fPWbSvHp4dX8+vDG6j64Q6znptB5AjKhwp/UaLoBdOE3IYFeNDIkwziZJml9va0ryU
         i65AScW8+m4bAflESQ/CUt/lRkKQLlLlEasVfwL8=
Date:   Sun, 20 Jun 2021 21:32:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtw88: Fix some memory leaks
Message-ID: <YM+X1pUFCLWprv+O@kroah.com>
References: <20210620192407.22812-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210620192407.22812-1-Larry.Finger@lwfinger.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 20, 2021 at 02:24:07PM -0500, Larry Finger wrote:
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

No changelog at all?  I know I would not take this if it were my
subsystem :)

