Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566D91B3B9B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 11:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDVJmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 05:42:05 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:34701 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVJmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 05:42:04 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M6m5o-1jZREC3epy-008IkO; Wed, 22 Apr 2020 11:42:03 +0200
Received: by mail-qt1-f174.google.com with SMTP id w29so1146268qtv.3;
        Wed, 22 Apr 2020 02:42:02 -0700 (PDT)
X-Gm-Message-State: AGi0PuYJ4lhnKrA7GvXIQgQLSMJ+uo9r824fjRAxNy/4+YijFINlsu2W
        47oMYVCOBwwP0MU+QRy+iM2SdDbG99cxRXwkUi8=
X-Google-Smtp-Source: APiQypLLKi9cLhzL0W2P5kqrtwWwlXVC0xXk3CH7HLud+3whDHwkik5qt+9WUyNmxGIdtuplja/aMpGLHcNc0ejrzo8=
X-Received: by 2002:ac8:4e2c:: with SMTP id d12mr25067709qtw.204.1587548521246;
 Wed, 22 Apr 2020 02:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200331183844.30488-1-ulf.hansson@linaro.org> <20200331183844.30488-2-ulf.hansson@linaro.org>
In-Reply-To: <20200331183844.30488-2-ulf.hansson@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 22 Apr 2020 11:41:45 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Nqvho82529dAi6oZhh0PgjiRfj=NLdNkkMfZ6Tw25iw@mail.gmail.com>
Message-ID: <CAK8P3a0Nqvho82529dAi6oZhh0PgjiRfj=NLdNkkMfZ6Tw25iw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] driver core: platform: Initialize dma_parms for
 platform devices
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:MMTRj86fwKfvoZWFKQYMmrK3zViJuqLn7Dx0RpoQJx1H/i3Ue5L
 S3n12a8r6sTC8ENA+hZRDav1L1/5tawehIpFKXJE7oUHQS4e1e01pTrhziREVkndouLTy4K
 s46ASiseUsyRfIkkJAVEnXWUd4LLoviiX6bDu2YFSerVctlW90pkLFhIH7c9buCjbAgVb5f
 4j/czMBojaviYlI/5vgNQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RMEJQvaPY2c=:wFZILn3iyycMGvldA+swCI
 M3gLjdudcxOC14+PRDD/g91GY3XGmN5h0YCuUiqSnoMv29n3/4ftiOJZVjL4PAp0eXKPZCfw9
 F8XjcL4Ha0DtR26BaSzbrhJAdeGFysGg6L1AZ13kt/0OUiPjOyeFlGWn0ScTQG0eBIZcPV7fs
 PDRfGY+FXCARqIyXAoKgAZXOtOZFiWn7Lv2C9qyOeF8ZeTyMT59aPc3li6u3XTnjLckD9vNRn
 sZYbdZBmq70j8RwUpnbTLtkuETfsMhZkGGM4RXdUTk35zEQW+4jBNQEga9ee8ojL6/t8iFTOV
 YSOBhMBr8JgTMTpSVdr17ahqvnZlg6eOTYDGIJPJZp0bE5eEwqQ765Er0bpMDQoQXYT8oeux8
 NaYx567ZlAA4q0DDmJFIxdhW7sX7tF0/F2wqbXN2C4zfmtypWmS3fZ4wZzmoPyGq7daNPDHNz
 UXUQlFgdMbikK/zk+H8uFvDbX67ISa1u2nkUjH9a05IkbpPyjCQ9wu9aqgVtrdlEYZ8Ee7K1I
 xWScRxFjpSpEBlksAH10E+PpqZpSUR96q6hHCwVOrBDDEfJSYVPJVfYg66FDzgNzPqj7gMMp8
 L12Vdv9g8NUfvQf9IcJ/4Dw/hyOXShLEecPsCyrjTaMOuCQ2455rj3n7jOMu4e9AfYgllhBRq
 kMX/RPveshV1PYidewyJiZZ4PZzjK30YGsLcNkjd4hLJyu6qU+Twj1FXnmxg4MioAFERfok+d
 aMEN6Wt+heJNkYehVFNLg6grpKl6jFw7V3kqL64qly9W5L+3OwLvfhqluXxfjLRGkWJlx4ER/
 DyPXZIFZPPl1J8tazibTf1CpxUotFmZT9UIlkob0/rPktgd5EU=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 8:38 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> It's currently the platform driver's responsibility to initialize the
> pointer, dma_parms, for its corresponding struct device. The benefit with
> this approach allows us to avoid the initialization and to not waste memory
> for the struct device_dma_parameters, as this can be decided on a case by
> case basis.
>
> However, it has turned out that this approach is not very practical.  Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
>
> For these reasons, let's do the initialization from the common platform bus
> at the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
