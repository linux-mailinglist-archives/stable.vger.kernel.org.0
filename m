Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FBA2737B2
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 02:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgIVA4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 20:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgIVA4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 20:56:45 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A0DC061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 17:56:45 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id v23so12700190ljd.1
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 17:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=n+oo6pXWfVKFSYrSUlzEDqSzkhwqZ/x07mqJw1kPh4c=;
        b=U3V6MbLW287al4gxM0GJFdqXFOw3BStYRHXBpf2h7RUMbxo3aMZu8XnBo+bCFXLVwa
         vnbWy4amYRZwbKR7lkLMZJ/PeEQgM335AFZc7g4zr1ndYDYK8GUfMDJ1pqLngDaq9pq0
         EZ65RQmu8tNPUCfwE4cZlPZWtjEgLZ5DFWKUYRcQbftWGXAyK7aJUxqKKOtt+xHUzZns
         Pvo7RG8Q7pGGdEQgU49URc4xyYWrpOhFWy+amrNUaYB6p79aZvftm692t4kI3+sdMquv
         X0ZhmegH1bnefaapX9Btp458u4zRWhXQegJ91GB0Mr7iaH93TMngBF0sGCPpYDdP8/s7
         3URg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=n+oo6pXWfVKFSYrSUlzEDqSzkhwqZ/x07mqJw1kPh4c=;
        b=mQQ4nyvj18wnz+RgEcdkXzEwXqhwowxOqpxfzI6vciTJgoSfN2t396QB7xLH7MePjw
         K9fTZcrHapmuN76XCuQvTNFU3ewXJ/XQWigFl4uEZ58NjBM81aKxuYvaPWJzOVvoL2bb
         ZYDRyK8iRUXagh6RICzq5A0vreh2iVzGj3BV2cSH2oEdILklzm8s/WZeLjx8zKyZm5Ap
         6mob7aqxwjS7UuxpBbP/hcfgrbqUrrIJ1P1P6ksS4dAUQPKmI/j8yzX+oefetqj0+WuL
         9onraiG6qiDtKRM1wWQCuxXArYs/efbmnwGFck/zDCKGvl7nr5lfVqsslyYPvuBEYEtu
         3vnw==
X-Gm-Message-State: AOAM533z9Ghsj4LVmyzT34USTG9Z+7qke8MzOrBt02g7t4yttp6nZT/w
        pFM+xMmHiazPunF1O29gQ7S343nLCJvENw==
X-Google-Smtp-Source: ABdhPJxcSGNTZebMzsdupK4+2Eb52Z9Hy1B7m65VwbqCRnKLcOgAjWVRFgj8tLee4ihQJqIC5LkTyQ==
X-Received: by 2002:a2e:8159:: with SMTP id t25mr663458ljg.137.1600736203752;
        Mon, 21 Sep 2020 17:56:43 -0700 (PDT)
Received: from localhost ([178.73.195.106])
        by smtp.gmail.com with ESMTPSA id p21sm3010836lfo.194.2020.09.21.17.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 17:56:43 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
Subject: Re: Sound regression in 5.8.8 caused by "ALSA: hda - Fix silent
 audio output and corrupted input on MSI X570-A PRO"
From:   "Dan Crawford" <dnlcrwfrd@gmail.com>
To:     "Takashi Iwai" <tiwai@suse.de>,
        "Hans de Goede" <hdegoede@redhat.com>
Date:   Tue, 22 Sep 2020 10:53:04 +1000
Message-Id: <C5THJRBYJNYO.2SX7AAGEZJ084@crawfs>
In-Reply-To: <s5hft7bph4i.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Sorry about this regression. It seems to be fine for me; if it's useful
I can post my hardware details and kernel modules to isolate the issue.

I've posted a new bug report here:
https://bugzilla.kernel.org/show_bug.cgi?id=3D209347

Cheers,
Dan
