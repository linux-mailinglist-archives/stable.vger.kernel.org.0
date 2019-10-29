Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904B7E91EE
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 22:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfJ2VVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 17:21:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35061 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfJ2VVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 17:21:20 -0400
Received: by mail-io1-f67.google.com with SMTP id h9so75388ioh.2
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wYgyp+k13CmNjqe6JpjmxZA3mhgN4aK1TYOFVpCR6hc=;
        b=tfDtsHPru0P4fiEaeRSH4JRbYVAPssDYq5hrXXxyVuYv/aVSu981SbOY5XEiWNdRMS
         DuAmcn7rhEZhwjULPhsgS1B7jHXTCaVswbuEiyk9A8iNfdZIdQ0anqBRdei6vSqurRnO
         GIiLfi4k4MOz5VMBHHz6xtRzeeZeuti9TM011M5fkEcNQ4JCGmpNiKpV8pnXSIaFFTFc
         U4D+h0eUesLSzrxRuFBiWuin3o6czj79HPOhbq4At/jk6gikqvOwhfPtNflIBEiTRbbQ
         4FeKVwdYZzybKCAMHEML5JZEWhHFrqTlFM8LvqULGzBoTMpOvinkW9dJvtGuyH5uqGYP
         nKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wYgyp+k13CmNjqe6JpjmxZA3mhgN4aK1TYOFVpCR6hc=;
        b=cnM4BXcg6qjOFxXiDJPDvPYOKprDKJXYpRPJszDjZUQebO1DzY7sk6PjT2KL/bYTfE
         EOpCeuiGeshszRQ/fHRPHybPtsDsLRjDX6dAUJ1Y/CZTqsnJMmmFhlyOBQfMZoSAMgEB
         1kzEj5HC2iEb7trhCeXRTktkXbRFj4AHM4Yc1RTkABKXOsJ4ZvigXhvbNY1behe1w+oW
         llvLsKF92A/wUv/wT0uznHKUdSiNJz+KH75neXx30tLXfBgArsgXNaWwgeduEf1w+oVo
         hghAUzIZkUxHYs0F1qK5cUyynlIMpVf9bk4sYrZItjruUeIvoUXhcSFo70wXN+PFEozf
         u/cg==
X-Gm-Message-State: APjAAAUi2c7oyWgg2sTZgVhAEvTqOsyuAuXPA91ZRg6ow1/StARU23TT
        bmcFvDXCJe+u81eyWP9Eej4N7pW8j6eQRiip7EU=
X-Google-Smtp-Source: APXvYqxcPxVnftkmQ6iXym4TQ3d1EcU21/OPeWU5ug3NmGcGKEBmgXyDx3CPU6GWFUS/s8cTtQgq2zks1oDkCjmKYWQ=
X-Received: by 2002:a02:7a1e:: with SMTP id a30mr14886995jac.103.1572384079292;
 Tue, 29 Oct 2019 14:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com> <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com> <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
 <20191029092158.GA582092@kroah.com> <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
 <CABeXuvpPQugDd9BOwtfKjmT+H+-mpeE83UOZKTLJTTZZ6DeHrQ@mail.gmail.com>
 <20191029181223.GB587491@kroah.com> <114dc6b2-846b-240d-db33-dd67aac51d30@redhat.com>
In-Reply-To: <114dc6b2-846b-240d-db33-dd67aac51d30@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 29 Oct 2019 14:21:06 -0700
Message-ID: <CABeXuvpEQoJ5F3vxjC4WUaUbKQJsdZJk-RERvwC1=YKG08_CyQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E3=2E8=2Drc2=2D96dab?=
        =?UTF-8?Q?43=2Ecki_=28stable=29?=
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, lkft-triage@lists.linaro.org,
        CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 1:08 PM Rachel Sibley <rasibley@redhat.com> wrote:
>
>
>
> On 10/29/19 2:12 PM, Greg KH wrote:
> > On Tue, Oct 29, 2019 at 07:57:05AM -0700, Deepa Dinamani wrote:
> >> The test is expected to fail on all kernels without the series.
> >>
> >> The series is a bugfix in the sense that vfs is no longer allowed to
> >> set timestamps that filesystems have no way of supporting.
> >> There have been a couple of fixes after the series also.
> >>
> >> We can either disable the test or include the series for stable kernels.
> > I don't see adding this series for the stable kernels, it does not make
> > sense.

I can disable the test from running within the xfs tests if needed.
But, how is it done for new tests that rely on features not present on
the stable kernels?

-Deepa
