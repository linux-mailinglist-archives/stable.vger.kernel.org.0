Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AECE3AF637
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFUThH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 15:37:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42416 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFUThH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 15:37:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E741B1FD45;
        Mon, 21 Jun 2021 19:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624304091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9h/HEQTP4aKAA1uhzkPRBK7LoX1VRn4NcLMYIxdPzzM=;
        b=RSvflSlW0WXne32QNSnE0Lt/zqkVpqgPKyZQSev7iCBbb24+WrCzB03LHdtvOfmfN0XdQW
        tUTLeiOC5xa6XLALp6DMxwGhzUIuft4M43HgfFFOOj0dRf1QoUlzcogVLc6gTLVUh3n88P
        ATVxdEYtK7z8MJPL1Ku+VtWZKBstsF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624304091;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9h/HEQTP4aKAA1uhzkPRBK7LoX1VRn4NcLMYIxdPzzM=;
        b=iW7eLx3P9ILsXjb5hbVZFQh+l83WRVq8S2uFGPqUb70w99ge1vuSoPweULTQpnX47qnMw9
        o18RUfPw0wyMweDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D3A01118DD;
        Mon, 21 Jun 2021 19:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624304091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9h/HEQTP4aKAA1uhzkPRBK7LoX1VRn4NcLMYIxdPzzM=;
        b=RSvflSlW0WXne32QNSnE0Lt/zqkVpqgPKyZQSev7iCBbb24+WrCzB03LHdtvOfmfN0XdQW
        tUTLeiOC5xa6XLALp6DMxwGhzUIuft4M43HgfFFOOj0dRf1QoUlzcogVLc6gTLVUh3n88P
        ATVxdEYtK7z8MJPL1Ku+VtWZKBstsF8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624304091;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9h/HEQTP4aKAA1uhzkPRBK7LoX1VRn4NcLMYIxdPzzM=;
        b=iW7eLx3P9ILsXjb5hbVZFQh+l83WRVq8S2uFGPqUb70w99ge1vuSoPweULTQpnX47qnMw9
        o18RUfPw0wyMweDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 9xgPM9vp0GBbfAAALh3uQQ
        (envelope-from <bp@suse.de>); Mon, 21 Jun 2021 19:34:51 +0000
Date:   Mon, 21 Jun 2021 21:34:40 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     gregkh@linuxfoundation.org, dave.hansen@linux.intel.com,
        riel@surriel.com, tglx@linutronix.de, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Invalidate FPU state after a
 failed XRSTOR from a" failed to apply to 5.4-stable tree
Message-ID: <YNDp0GXOi/JQ4pse@zn.tnic>
References: <162427270623162@kroah.com>
 <YNCiQRPD9iox9g/v@zn.tnic>
 <5c9dc791-f34e-e26e-9d34-7f5280d3990f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c9dc791-f34e-e26e-9d34-7f5280d3990f@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 11:42:01AM -0700, Andy Lutomirski wrote:
> I agree.  The fixes line is indeed wrong, and the (horribly misnamed)
> fpu_deactivate() call did the right thing.

Thanks!

@gregkh, then, you can ignore that one for 5.4.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
