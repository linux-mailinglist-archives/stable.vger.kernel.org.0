Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC006595F49
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 17:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbiHPPid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 11:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiHPPiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 11:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A6185FF0
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660664237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uLgzpNhVhUG9A2bn8QNHqooQAG1AEVMq4dTPM1EVWNo=;
        b=UH4O7gcpRwT96A4/cEChZ1lwKyDeDnTOxtNhZq0JZybSaTG8p3dVnIUWbiE49MYdMUo2Pf
        sjd7mdvHo+TTpYIOYoLrYmUPPiAud70VMqalfnld229QkJxtawYOxyQZXIdKTrCZ3CKMv+
        cFjhbOyiZj+Zbb6Q0HWYfaM1kEU+Dac=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-264-17NJ-PiPNL-wj79xEJ1Aig-1; Tue, 16 Aug 2022 11:37:16 -0400
X-MC-Unique: 17NJ-PiPNL-wj79xEJ1Aig-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-334370e5ab9so16454277b3.22
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 08:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=uLgzpNhVhUG9A2bn8QNHqooQAG1AEVMq4dTPM1EVWNo=;
        b=Voon9EoDYcp8jq7ovBl8uMQ0B7DwXTeJN69sWes0UoVbXKl6Tm6mr8ppHNyahCiazS
         H1TsSk7Dw8D9UDoX99vt7sr223/2Yn+RkYtrE++sNB2TfQVMj9+ZtuRY3DU9TWD8QKAx
         94IQnh/ijuUoCee6F8tZTHCd6cX+bbf7SNQMdTsQezse1nUgK+3tPHN8yJpw5NsXsaf/
         23ktE4VlcXTTmtgBQHT73T39gK0YtUcVIDn9gssnA2y6u6CG3Ux9Q/+BHzvpg2HJLbaK
         61mIbkF6uWDaWnzd5NXfazLZjKyzlD9aIOEL1YQ1MDM0RBiVt0ysrS/ld9/H2oL33+cs
         CVIg==
X-Gm-Message-State: ACgBeo0OSX3OndsS8q3U6D0A+g6H4P5lkREUJHtfFqZiT9LMy+8QH986
        ABce+2mWv0YqQ8pAhga8j5b7/EsFXPzhvhciXhXWuu5OmgRuZYmmL3gNKfVojZM524O7Q3lDCSA
        mtuAntVWYTu8zLnuib88AL7YCxmSIJxuq
X-Received: by 2002:a25:51c7:0:b0:677:8cf4:6ef with SMTP id f190-20020a2551c7000000b006778cf406efmr16149454ybb.492.1660664235575;
        Tue, 16 Aug 2022 08:37:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6/IZiWtUywCtbZdm9QXJq1ifTtZpQTap8GV99KB9piyzwlj4yOx1LMC9lAhjRs2DwM2dRb8xX8I49lgGYCyEo=
X-Received: by 2002:a25:51c7:0:b0:677:8cf4:6ef with SMTP id
 f190-20020a2551c7000000b006778cf406efmr16149441ybb.492.1660664235383; Tue, 16
 Aug 2022 08:37:15 -0700 (PDT)
MIME-Version: 1.0
References: <92005.122081607111901341@us-mta-567.us.mimecast.lan> <YvuFfp/wfn4UFYpn@kroah.com>
In-Reply-To: <YvuFfp/wfn4UFYpn@kroah.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Tue, 16 Aug 2022 17:36:39 +0200
Message-ID: <CA+tGwnk-oaPVFzbRebJbtrkgiPtaQRr=d83kzdxZZGGjQUuCbA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_122bb8ac_=28stable=2Dqueue?=
        =?UTF-8?Q?=29?=
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 2:05 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 16, 2022 at 11:11:18AM -0000, cki-project@redhat.com wrote:
> > Hi, we tested your kernel and here are the results:
> >
> >     Overall result: FAILED
> >              Merge: OK
> >            Compile: FAILED
> >
> >
> > You can find all the details about the test run at
> >     https://datawarehouse.cki-project.org/kcidb/checkouts/41055
> >
> > One or more kernel builds failed:
> >     Unrecognized or new issues:
> >           x86_64 - https://datawarehouse.cki-project.org/kcidb/builds/218267
>

Hi Greg,

we fixed the issue that caused the lack of notifications for build failures
(hence me sending the email manually yesterday), and that in turn
caused some super old emails from May to go out. That was less than
expected, and we're sorry about that.

> Am I going to be forced to click through to find out the problems with
> all of these reports?  Why not provide the error log?
>
> The error log isn't at that link, where are we supposed to find it to
> figure out what went wrong?
>

The logs would normally be available, but as a consequence of the
old emails going out, they were already deleted.

We're also working on a reporting mode that would add the failure
log links into the email directly, and for build failures, embed the
traces in the email body too. Would these two provide a suitable
solution for you?

> > If you find a failure unrelated to your changes, please tag it at https://datawarehouse.cki-project.org .
> > This will prevent the failures from being incorrectly reported in the future.
> > If you don't have permissions to tag an issue, you can contact the CKI team or
> > test maintainers.
> >
> > Please reply to this email if you have any questions about the tests that we
> > ran or if you have any suggestions on how to make future tests more effective.
> >
> >         ,-.   ,-.
> >        ( C ) ( K )  Continuous
> >         `-',-.`-'   Kernel
> >           ( I )     Integration
> >            `-'
> > ______________________________________________________________________________
> >
>
> I have no idea what the subject line means, sorry.  A random git commit
> id with no context isn't helpful, what are we to do with that?

Would it be more useful to provide a branch name in the subject as well,
and a commit description in the body? Or something completely different?


Thank you for the feedback!
Veronika

>
> thanks,
>
> greg k-h
>

