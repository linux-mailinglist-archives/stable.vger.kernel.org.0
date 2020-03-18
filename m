Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623E11895F1
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 07:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgCRGlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 02:41:42 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44665 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCRGlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 02:41:42 -0400
Received: by mail-oi1-f194.google.com with SMTP id d62so24533253oia.11
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 23:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hM0cpXp7RSKNn1lZVtejbipEk/jiFWNrNvwo++TDYOo=;
        b=Z5QxTJS7anNzaITsd+QcGv7EiJD1BqTar8NM5zTYDnngRB3NdZePyzWf+FEnamM1Qz
         baEp2FDaUDFVEiNnjLZ5SmpW86e8lfYcavpCiIvockHYpEt666YmvpA6TiJY4Fk/F9Jg
         7C7hOdqyzsCnxHze7gsInIxlK0oJY5iIz/0L0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hM0cpXp7RSKNn1lZVtejbipEk/jiFWNrNvwo++TDYOo=;
        b=LEOe/g0b/ugy5sT7Cac3S7KIEoWVT4fAq/47ibL0O+IfuO5G0loWJxWY9xFon0QZ7J
         G0MiAJkVvroe5qQbuY9xEdJkay6cKo+nKqE1T3bD/bX2yDKvVfDwm/0nz6FeDRyIAGHd
         eQJ1syNcGVWMGqAbQDCa62Gnhfr8JsrXlsG4VBuEe4UOCHjiJ84E6dn3weMmRX92gs5w
         85oM2C9NaJ5KbB+u+KyFc5BeOefbweyJyLGSxkiwety8dugkFw3UoFSaYEthmRPmTLV3
         iOkfQH/KUUro6d14Be5stCC4Fcte1oppqGtAwYG8pALiI/wOEurGzPOOHpCDc2aG1EWm
         pGNw==
X-Gm-Message-State: ANhLgQ3L02TY92PL1L3PaoWJB+T0ryqvLEXhopTgDTc6sB67emTt57XN
        UipbasMhgxjURUvglgIxj5UD7Pcn2J21wLqOrnAuQTpzSo4=
X-Google-Smtp-Source: ADFU+vtwJS/04e/sPRotCIfgO5c8RWhXtXX4RMO+Aniq2R5Pxlfx07gegMaHzJ0Nd4Oydw5aCjPc3VkCtiMQTmvFn2Q=
X-Received: by 2002:aca:ab4b:: with SMTP id u72mr2136672oie.26.1584513701482;
 Tue, 17 Mar 2020 23:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <1584001735-22719-1-git-send-email-sreekanth.reddy@broadcom.com> <20200317223026.0B8E020752@mail.kernel.org>
In-Reply-To: <20200317223026.0B8E020752@mail.kernel.org>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 18 Mar 2020 12:11:29 +0530
Message-ID: <CAK=zhgoabpaMCfJ6WOqzwnzRhDNwHwL=se=bj7_vAz0NKr1UJw@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 4:00 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.
>
> v5.5.9: Build OK!
> v5.4.25: Build OK!
> v4.19.109: Build OK!
> v4.14.173: Build OK!
> v4.9.216: Failed to apply! Possible dependencies:
>     c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
>
> v4.4.216: Failed to apply! Possible dependencies:
>     96902835e7e2 ("mpt3sas: Eliminate conditional locking in mpt3sas_scsih_issue_tm()")
>     98c56ad32c33 ("mpt3sas: Eliminate dead sleep_flag code")
>     c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

This fix patch is applicable only for below stable kernels,
v5.5.9, v5.4.25, v4.19.109, v4.14.173

Please let me know if I need to resend this patch by specifying the
list of stable kernels on those this patch is applicable?

Thanks,
Sreekanth

>
> --
> Thanks
> Sasha
