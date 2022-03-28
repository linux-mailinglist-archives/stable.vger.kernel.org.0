Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091A24E927F
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiC1K3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 06:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239032AbiC1K3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 06:29:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38443B3C5;
        Mon, 28 Mar 2022 03:27:42 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t13so10668540pgn.8;
        Mon, 28 Mar 2022 03:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uHDDa0XZK41WRe8STib1Z4AK0mYc33NWhGIfT2U3Az0=;
        b=hZ7VAWi7YWynf1sfmUIZPLIY35mO8PQixPrJhlhXbcCym6ePpBdpBe0WyjE57VpMk4
         exvAEndq6f2flrQmPLUKEgJuVHgGsIvkFzC1P2p+/Yzv77gg4RJPBKou5pNx9dCTs0U5
         RpvV1XSJx2yHveWGUWtiJoBnab3uD8ZS8DL0fSsjzqNuWV/dRfdBFIR2r22fJqf6oL+/
         Wv7kAPAby7XODegszVbk8F/KDbrJRLVq1187fuIG9rjsqEXQ5E2e5JnnfyRSD2jrQtuO
         XmeW6whNMgPGaZ3g01QtSmieRKzb2uzwEpduaKXMrdEVuVDSTXtFBPnB8c1wYL0FnBtG
         U9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uHDDa0XZK41WRe8STib1Z4AK0mYc33NWhGIfT2U3Az0=;
        b=PqIfDUWEetX1TzECcVrsNIiJCTLu0KaXAH/0BYM57wprBjJMuySNgiLXg3wvBdVVNM
         keFlK6dSPMu9u9ALDIwm4cnKPFQQrQddxURDQZ641pgdNjnwshDMHam8p3LhmLdphXd3
         CfYDaCOC5/u/3fnMQKm9LL5tuy3sECZVE4DzWgTj61xGuUKSXOsFqZtStPzA7MPvzJLZ
         kwsGVUyBoHoEhKd23kD8qDo6lyfIIZcslH/1mLL0k7hNUdamfM9nhl3pXjIjIHG0s69X
         +1VX50mNeBQLZI9D/9t+IZ3mmsyjOWYSlIJKgZRAIEUrL00YKU2ZPEvDV/N/3z/pPWLH
         jIuw==
X-Gm-Message-State: AOAM5300w/uqnZJTSkF/VrBUZqPfUPA+eVm+eLA8bVziTx0ca5QrF8GP
        aEjymRF64TUpmolc5iBHArs=
X-Google-Smtp-Source: ABdhPJzxcabcTL3XHVJ1uRQp4H+1DZMMpQvdaJio4nqezpvP6SzBPuRKnoYFqp04b41ZR7L5TFMoCQ==
X-Received: by 2002:a05:6a00:24cc:b0:4fa:a9c5:4b04 with SMTP id d12-20020a056a0024cc00b004faa9c54b04mr22889106pfv.63.1648463262207;
        Mon, 28 Mar 2022 03:27:42 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id q6-20020a056a00150600b004fb2d266f97sm8258542pfu.115.2022.03.28.03.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 03:27:41 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jirislaby@kernel.org
Cc:     agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        dsterba@suse.com, elder@linaro.org, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com, jcmvbkbc@gmail.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, svens@linux.ibm.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH v3] char: tty3270: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 18:27:32 +0800
Message-Id: <20220328102732.28910-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <47a6e396-3d51-79f5-a544-8942470fa2fd@kernel.org>
References: <47a6e396-3d51-79f5-a544-8942470fa2fd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Mar 2022 12:09:59 +0200, Jiri Slaby wrote:
> On 28. 03. 22, 11:35, Xiaomeng Tong wrote:
> > The bug is here:
> > 	if (s->len != flen) {
> > 
> > The list iterator 's' will point to a bogus position containing
> > HEAD if the list is empty or no element is found.
> 
> Could you also explain how that can happen?
> 

When list_for_each_entry_* do not early exits (if the list is empty
or no break/goto/return hit inside the loop), it will set pos ('s' here)
with a bogus pointer that point to a invalid struct computed based
on &HEAD using container_of.

#define list_for_each_entry(pos, head, member)                          \
        for (pos = list_first_entry(head, typeof(*pos), member);        \
             !list_entry_is_head(pos, head, member);                    \
             pos = list_next_entry(pos, member))


> > This case must
> > be checked before any use of the iterator, otherwise it may bpass
> > the 'if (s->len != flen) {' in theory iif s->len's value is flen,
> 
> bpass + iif -- others already commented on that and you ignored them.
> 

Thank you, i will correct it.

> > or/and lead to an invalid memory access.
> > 
> > To fix this bug, use a new variable 'iter' as the list iterator,
> > while using the origin variable 's' as a dedicated pointer to
> > point to the found element. And if the list is empty or no element
> > is found, WARN_ON and return.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> That's barely the commit introducing the behavior.
> 

So just remove the Fixes tag? or something else? I find this commitID with
git blame.

--
Xiaomeng Tong

