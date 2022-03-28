Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6854E9C56
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 18:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241995AbiC1Qgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 12:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbiC1Qgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 12:36:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E05217E07;
        Mon, 28 Mar 2022 09:35:03 -0700 (PDT)
Date:   Mon, 28 Mar 2022 18:35:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648485301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WQ9y5Q9s/w3MIMKLjGYVu1WkzeaCyMYyLpEhNQ5RFMA=;
        b=RhQuQ78OdtQpAJiHUc6s76DRQot0Qs/FIZyfU+KZtQrNHl9XELFhtjzEE+C+hDqhmrE9gM
        XYuYv1QVMCFRQmJ0wy6bhS+jRx8U4jN/acwhH4OhNkBxvJ0TgC/H7CrGOAjid/cu9Ed5Wo
        i9m2yzmwzeYu6bRG/zLsKJMQhVhhRFKlB6zncQCCKHnxBbAfAnwm2TnsZvI+8eeni7iqfq
        wNIwBjAJbAxO9MTUTvmBlUpNKOR2vBjmWkZ3N5tkXT9BeGtWAHxRUllz8BSpYkzbMgrjzg
        GanpaJeoGsQ4KujWr+wNI/wQO3AD4PraJfEMBRZsvx7Fd4hF/C7Tyvt8qDM/qQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648485301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WQ9y5Q9s/w3MIMKLjGYVu1WkzeaCyMYyLpEhNQ5RFMA=;
        b=Wlc63L6aju32oJu5NwDIEusBnikS2J2ueOqzGZ+DXjHz+Ry9sLqXwGNUZlcP2xnihvAJkP
        HV776v59HaU7i5AQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, luto@kernel.org, frederic@kernel.org,
        mark.rutland@arm.com, valentin.schneider@arm.com,
        keescook@chromium.org, elver@google.com, legion@kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 29/43] signal, x86: Delay calling signals in
 atomic on RT enabled kernels
Message-ID: <YkHjtMX9s/bA83OT@linutronix.de>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-29-sashal@kernel.org>
 <87r16mw3l4.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87r16mw3l4.fsf@email.froward.int.ebiederm.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-03-28 09:31:51 [-0500], Eric W. Biederman wrote:
> 
> Thank you for cc'ing me.  You probably want to hold off on back-porting
> this patch.  The appropriate fix requires some more conversation.
> 
> At a mininum this patch should not be using TIF_NOTIFY_RESUME.

Sasha,

could you please drop this patch from the stable backports (5.15, 5.16, 5.17).

> Eric

Sebastian
