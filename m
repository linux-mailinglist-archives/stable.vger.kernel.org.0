Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7767FBF4
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 01:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjA2AYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 19:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2AYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 19:24:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF421C588
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 16:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674951830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kh4675yGn7de7rBJaXu0/haUPHaSoFQ5kB4OsX1qKq0=;
        b=TpB0cH1ekI5mmFyUPdoFlM343gU942lSMRBpjpI7odBi1JoaDf60FihSzTDET4ZlqWxdMA
        5NTt3pzYabwsbPXlE6YUJq8P2/Xon7u74we5ODj0ME6ygcTHTgLNtz9s02xBofVcIhfcxw
        HosUhwOoH6pZCFINm5gzDT4CmC/FL78=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-PqOIlVHINxuDoDt41ZWKeQ-1; Sat, 28 Jan 2023 19:23:48 -0500
X-MC-Unique: PqOIlVHINxuDoDt41ZWKeQ-1
Received: by mail-yb1-f200.google.com with SMTP id z9-20020a25ba49000000b007d4416e3667so9449531ybj.23
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 16:23:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kh4675yGn7de7rBJaXu0/haUPHaSoFQ5kB4OsX1qKq0=;
        b=zVvmxAG6ectDFhUQm3H3KVvtVzt6InZbVpHT83RmHTFAMFiAtn2EDR8NFrXxhKqNl1
         uOKsz4uBBJaqLuwvUTAxSHJjcWiEzxvW+MEyhewIkmNjN8tzW+MrIBeIeDJzCSuE/4KH
         yfBriit0pLUgoAQWxOE0cG9kpHL6WPfiE8o44Bm9ak2q6pOE9rr8TOQPOJ5s264m5tZT
         tZ8ZsX2MvjEotA2ybSfN2Zhy1vR+ofvSo5ht/h7FoECJuc6CUsIsAJVeUaVCTDSGJ3Dr
         OH5c3CarobL4wlJaDWxRspJhY0MzFSoV8QQLfyrlDvl9SRDj2yf+1r6W339dDQiyfFcw
         PJbg==
X-Gm-Message-State: AO0yUKXv5QeHBiAomo3Nm/TovmIR8TGtXBh+i0jMi+H1NzKyXSv34eVK
        USIdHMqA3QgW61HP8aag1HyFpUqrP/KU5rtU1cNttUlrV8V9af6O6YKm3ZrrXbt9wuyOrwNPk3V
        BZAFJT1jBunuripspSNWW2X9xgK0GUt9b
X-Received: by 2002:a81:b70e:0:b0:50a:87fe:1e45 with SMTP id v14-20020a81b70e000000b0050a87fe1e45mr1023399ywh.338.1674951827255;
        Sat, 28 Jan 2023 16:23:47 -0800 (PST)
X-Google-Smtp-Source: AK7set9VRK4eguQ/LeiMtOEJbGgCXqEogdn0mkUQqG3AMy+yXBObnoLUE8K2Q58QH+hLrdAZdqkQdhPRNEsdzL/eYFA=
X-Received: by 2002:a81:b70e:0:b0:50a:87fe:1e45 with SMTP id
 v14-20020a81b70e000000b0050a87fe1e45mr1023393ywh.338.1674951827077; Sat, 28
 Jan 2023 16:23:47 -0800 (PST)
MIME-Version: 1.0
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
In-Reply-To: <Y9Vg26wjGfkCicYv@kroah.com>
From:   Jason Montleon <jmontleo@redhat.com>
Date:   Sat, 28 Jan 2023 19:23:36 -0500
Message-ID: <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     casaxa@gmail.com, cezary.rojewski@intel.com, lma@semihalf.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        regressions@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have confirmed 6.2-rc5 is also broken and removing the same commit
causes it to work again.

Thank you,
Jason Montleon

On Sat, Jan 28, 2023 at 12:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jan 28, 2023 at 12:09:54PM -0500, Jason Montleon wrote:
> > I did a bisect which implicated
> > f2bd1c5ae2cb0cf9525c9bffc0038c12dd7e1338 as the first bad commit.
> >
> > Reverting this commit on 6.1.8 gives me working sound again.
> >
> > I'm not clear why this is breaking 6.1.x since it appears to be in
> > 6.0.18 (7494e2e6c55e), which was the last working package in Fedora
> > for the 6.0 line. Maybe something else didn't make it into 6.1?
> >
> >
>
> So this is also broken in Linus's tree (6.2-rc5?)
>
> thanks,
>
> greg k-h
>


-- 
Jason Montleon        | email: jmontleo@redhat.com
Red Hat, Inc.         | gpg key: 0x069E3022
Cell: 508-496-0663    | irc: jmontleo / jmontleon

