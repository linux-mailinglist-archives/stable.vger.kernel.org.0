Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E151267B7F
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgILRDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 13:03:32 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:57949 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgILRD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 13:03:27 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MlwJv-1kzn5i262V-00j2c4; Sat, 12 Sep 2020 19:03:25 +0200
Received: by mail-qk1-f170.google.com with SMTP id q5so13046377qkc.2;
        Sat, 12 Sep 2020 10:03:25 -0700 (PDT)
X-Gm-Message-State: AOAM532YYb7pYi4ysDzOIk8XprAbqp5lOYLjABWnOcCmdlXYUUYPizWz
        M+xdmwGDEXf2omLoViJW1IDQkPv1gQ5SKl6H3LE=
X-Google-Smtp-Source: ABdhPJwrFDiQN6ar3nG7uFmwIH05x3gLlT9Xo/ra0kyl9Nr9O28w9hfUNyR7+vG9Vv9FPreMq7aWAM44U13zJtHoAhc=
X-Received: by 2002:a37:a483:: with SMTP id n125mr6418718qke.286.1599930204172;
 Sat, 12 Sep 2020 10:03:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-2-arnd@arndb.de>
 <20200912072053.GB1945@infradead.org>
In-Reply-To: <20200912072053.GB1945@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 12 Sep 2020 19:03:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1ymnvnAjdcO3Dzfy9bp4LO-2uhtimOkrmFStynJYXrqQ@mail.gmail.com>
Message-ID: <CAK8P3a1ymnvnAjdcO3Dzfy9bp4LO-2uhtimOkrmFStynJYXrqQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:hbMAjJDifK2HVVhi27X5Besa5VEM3hTSvOoV1MK/IerO8sGzQjV
 6iV4Ta6BpFB2HGCeo3d0feQUcq7c9Vdq/YOT+SbHa1VY6N47rU//ptvJ5Qv7p9d/Wg9+kmi
 1qfqSP7vGUrSa2aNfOe9wL3y1qwUkH5sTrt3BkZMCkG/wgpps4RVce/BckAmh+inNgTdxDR
 ahEs0/Q15WqJSrkYKDDNw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:q/7iCtCs4Ew=:peIsGLb79b+/RHge38VB3M
 okC4WIhEPCfDdABZPI6XYuN6Z4H9bjT4h0zWigyT6qPxyTysQNHkAoJbeM+Vqro4NOPmKj8+r
 BO44JIXF6sF/gdmnXE/i2DyqlTvwzxHpATM3sEl3TIg94BgKH6VV+Td9kbGKH8zZ7rY/B4DzT
 1BEX9RXGl3ZK+RfdFBxKBNA6BYJSFPhnou324FibIecbi3Q9vic+BMhK/uRNpZnvBLTyHd1rQ
 HzL8XhrVhzFAyaGF6D90WEXteYuQy5wIopMsNkZiOxuvPTLKipCJoSU+8fXP64Okek3Bo8AW3
 qhurNFP15tdhclxLjTpizoLtD9dB6F6steziwU2yRnoHPCg9TtZpigRF9Wumr9mfmmbmPTaNE
 yxtAEIRYQ0si9jVL7Uw26qnrTYdMoss2Lnq60Id0Xs6muC/CCJzmVwsOLPVI84KjU1HIFfYIZ
 SHDSZhii1EsGt9HPZLxt1+3ARq8CzsKEJvgsVSF0TGhDm8uEtmb9twoJmZIUWpAfqutpWT6BQ
 9HhFvYZ3wT1v+q1vwb7COoBmUOfWyqvKZR+iIojX0WKsEo496pfwWdfsWtX5Z8sZ5ec6a9PwV
 h2sfSo2wGQBs4kvJ+AHSCPiPQGGOBxwEdUXTeKVQ0ZKpl94dSa8KvNZCI+gs/iYfKZLFe124N
 YynUUlaZtg6+R9JORRJ5tENomBFWIqseSyOieboMqvL/psA09XIeQ33TU32J+ZxM7l2Qi8qBf
 nYteDh2NcWUAQfGxbCehE4u3TQUIUbu0wks7gTD3LSACLFPMMPIZ2PL9P+YPmPkDcqCLn/+x6
 JIZuD9h8c4lYkvRuiWBfBzeG0InUhv2q6tzlVq8ALbrS+5beVFsXQIOl/bPoKdTbKwGnoCJb4
 S6wHh7lrfOQYqZtDYuP1C4FHs5xy7W3PujeZfk2QwrL16eFb2jfgEnqggEcW+ojiMXq+AcuOz
 +RLl86lSXgbiesPOmbdCGTInaZzFM6FimEwMat/e6F9ZVJhM8lzmy
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 12, 2020 at 9:20 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Sep 08, 2020 at 11:36:22PM +0200, Arnd Bergmann wrote:

> > Cc: stable@vger.kernel.org
>
> What about a Fixes tag instead?

Sure, I can add that. It's been broken since 2.6.15 though, when the driver was
initially merged.

     Arnd
