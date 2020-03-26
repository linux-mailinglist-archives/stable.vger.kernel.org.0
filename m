Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D17193D9B
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 12:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgCZLHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 07:07:37 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:38767 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZLHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 07:07:37 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N2V8Z-1jNhhA3NJH-013wQI; Thu, 26 Mar 2020 12:07:36 +0100
Received: by mail-qk1-f182.google.com with SMTP id q188so5863667qke.8;
        Thu, 26 Mar 2020 04:07:35 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2oj/kyk3THVH7gxkjwDWcC+sb9lKEmkT8YfuICxKJ/v5Hiy4BP
        DgfLiXKczZvKpIUCgmC0zckDDyQgcqTC+WPhLrs=
X-Google-Smtp-Source: ADFU+vtGA4H8mWbkDm6gpTVbfvnOBJmqFtB227gJd/fzaEEWWXK9KVIZa3FUqSbrkQ+QzfbwJV3lxH63RATvQa45OLc=
X-Received: by 2002:a37:6285:: with SMTP id w127mr7344230qkb.138.1585220854524;
 Thu, 26 Mar 2020 04:07:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200325113407.26996-1-ulf.hansson@linaro.org> <20200325113407.26996-3-ulf.hansson@linaro.org>
In-Reply-To: <20200325113407.26996-3-ulf.hansson@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 26 Mar 2020 12:07:18 +0100
X-Gmail-Original-Message-ID: <CAK8P3a39JrMrYrNeLCr-R6y-ivkVqRkxey_Z7R4N3++MA_qqCg@mail.gmail.com>
Message-ID: <CAK8P3a39JrMrYrNeLCr-R6y-ivkVqRkxey_Z7R4N3++MA_qqCg@mail.gmail.com>
Subject: Re: [PATCH 2/2] amba: Initialize dma_parms for amba devices
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:so40XTW2CTC1HkSymfhx3VW0SvDDnr2OiAQD99FzniBB8rp8Hoh
 eYk8A4SikJYNsUZnKxZATfC+qbxnFqgxxdz4YynLKJPZFAvFmmbl9jI0mkwoDi7zA2RB1eY
 0Irc8U10Vd0x5c+Jx1qkwqFgpbXYcqZyNE3NeS6dDEfIO/AteCc7qoKGj4wHIijNCx+Im8Q
 hqjsK8IMP/44wZNSFgPVQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5PfRy+YWNrY=:pm0+ufywHfccSZzfh5UJ0B
 MxzGYSVAB+K69Sd64I5xnPRT+53rJQrDX4GG+ukHHZEu17ki90OMmE2Ccs+TG4IfZhgFQItHG
 YDxYo3irD5Zn6hKNTwIfguhnnq3ON+l8H7VkVUKGbcSVs4zO2vRVQJyz41HL0QnlUdVmioavR
 rzorTdECBJFvaXkT2HbENTxya5AoGLr7WVTIKyQ4OchgAxnxEs7Aw5peEQDu+uEfQ3G4CCs98
 PGlrWFiW3X5jii9dfBrL5tTdHtsUNhQNQhtMcvOyv5vezDyRN5HDZyAcL3Y37TPfKM1RX11G3
 crkaQpKcEdbuVn1kG6RWi6Czzjh2NGUSTdtARdRAi5miWQqcstoh7IvU2tct+L9fyTtfIAfdb
 cQ6Xg8VymcKqeNHlYpat9WkCDl8lOXo0ED7V4cvyURiqZX5xmz1mNkipFa5+ebpEdZcdRxtsJ
 s1K19JhB7v9Oay1wzgWZGysCSs/duNmogTjKJeQDovIpu7hoyl7oaS9rnnW8cr4h8IZacqfC7
 eP1f9LVyzoNkCOoBaWBYuZ8WRk/RfjmqZsP/v0+qzlo7oNecJs8lxwwf09PydOpLJKhoSbrNM
 8yZYvBTY5ZlAinELkM7QODt0DR69NpjGXzTF+XKGohNktImtoeHiBOzs6NdnmU/p6dlTSydqE
 7q5UnJgUS4jPbcSWKg1L5/x9AJBXjsi7NaFDB5mcawUGICPR/PmHwnhK9F3ANjqZu8bcC31v0
 THa/iRdt2+RSdGtTHkAUUvYVLhnxWWwJRFxM5wI+1l+Is10AeH2Gbok76auE47oi/FRtyONtT
 TVDWDlrXk3Et0Cpg4TCK/oBFyfGSciIybmLPdhIT74JsohOOXA=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 12:34 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> It's currently the amba driver's responsibility to initialize the pointer,
> dma_parms, for its corresponding struct device. The benefit with this
> approach allows us to avoid the initialization and to not waste memory for
> the struct device_dma_parameters, as this can be decided on a case by case
> basis.
>
> However, it has turned out that this approach is not very practical. Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
>
> For these reasons, let's do the initialization from the common amba bus at
> the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
