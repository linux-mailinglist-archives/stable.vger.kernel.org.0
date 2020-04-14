Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA751A7EAB
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbgDNNnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:43:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22783 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387951AbgDNNno (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586871822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uGnOkaApoDtvmT4rb/45fczLTGG4cswRXC2P9ZwfGKk=;
        b=dQFLyDgHy2a6QedLmZUcYSNeD9LIc8QAAjxq/GyxPsOZ7524EkRFjeRulChoLiGrf+apWZ
        RcsBOv+20pny6q6vwVn4N4t9VdNkiG2QIpoKN4r9Nu3GlsUHxf+aLD2XPjaYHPhb0Ug8Nd
        YZayTNWBjH7CWfFqEU4dzD6TDBQXbQU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-t7bnw20lOf6qwLpli3P1Sg-1; Tue, 14 Apr 2020 09:43:38 -0400
X-MC-Unique: t7bnw20lOf6qwLpli3P1Sg-1
Received: by mail-wm1-f71.google.com with SMTP id o5so4253385wmo.6
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 06:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uGnOkaApoDtvmT4rb/45fczLTGG4cswRXC2P9ZwfGKk=;
        b=qaOJMauK82JYqj9rch03uBbZLLPAh8/8/s4vDJpzWqQPBS29B3tmxKeS28ZEa9YDz+
         9HGdTFla4QdfmsXKgRM6LMvkZ8By2R4m1VCvYOzE62+hCsNuA1rhyL0hS3EwAoW7kwFA
         AZW5sa4eRQyxe4VYPazs97/U/mXPPhCNqQB8/ys5yjy0LRgyZVJfr59reu5RbwrF0DhB
         54715zSefOAabC72+yDev66GBYKUltc2pD5gLNW6zycg5u4R0G7GnHW9IzOCqH1T5vaO
         JqDT2ifw/N3qwl0q45iA+/muEviu3E0GSOdlBFAUEmPiSzU1YfXo++lkRVpTe4BIknyl
         IX5A==
X-Gm-Message-State: AGi0PuZrWqqKHBFUjLGC/5D1Wuh+gys3PL55zb5+mkUZNYcVpk6llF0M
        hU+RYh/wg7bDi0+dtDWxye1V8Xz7pC9boqJw2Uomvj6OL7/RrEiVX5UhQ8w9rs2syazuFTkJeXN
        bTLFS1vcFEx21mabk
X-Received: by 2002:a5d:5707:: with SMTP id a7mr23873159wrv.108.1586871817498;
        Tue, 14 Apr 2020 06:43:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypKxXewFxmN5wg0F9DVRnVTY+zLKue1YLilAQwX8+whLnQLEknRjwtzR2yAUJq2cnu7LLu/Bjw==
X-Received: by 2002:a5d:5707:: with SMTP id a7mr23873148wrv.108.1586871817330;
        Tue, 14 Apr 2020 06:43:37 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h2sm562886wro.9.2020.04.14.06.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 06:43:36 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: FAILED: patch "[PATCH] KVM: VMX: Always VMCLEAR in-use VMCSes during crash with" failed to apply to 4.4-stable tree
In-Reply-To: <1586870222160177@kroah.com>
References: <1586870222160177@kroah.com>
Date:   Tue, 14 Apr 2020 15:43:35 +0200
Message-ID: <87blnuyygo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> writes:

> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Personally, I don't think it is worth backportint to 4.4, however, if
someone thinks differently please don't forget to also pick up

commit dbef2808af6c594922fe32833b30f55f35e9da6d
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed Apr 1 10:13:48 2020 +0200

    KVM: VMX: fix crash cleanup when KVM wasn't used

or things will regress.

-- 
Vitaly

