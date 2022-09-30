Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E275F0B28
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 13:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiI3L4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 07:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiI3L4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 07:56:36 -0400
Received: from premium237-5.web-hosting.com (premium237-5.web-hosting.com [66.29.146.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF99156FBA
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 04:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sladewatkins.net; s=default; h=To:References:Message-Id:
        Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Subject:Mime-Version:
        Content-Type:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LJj4mKlEBcLfMkBKz3ZsW4f36QAglRn290JP7xXCOTA=; b=CGd6CBQUf5YGwZ3kdZCcwkS3GK
        hYIF5yCMJEkTC6Pi75mbVhZ67GNv0TN63eKFj3xLTajpxA4TGW6wjIJHKJLl109klogkwz6xqM7l5
        y7+aJ6F7uUOoWRpOAC3AHJmIdEYIUufVqQD1V4VS957cGwB1pSm+We9/CGxXjJRcsVwDT1PBN5jYP
        BIrfZfzowLyBKgjceMqjPtYyrp/WRjkaXhVO7iayw9WNfA20/mQ5nk6cP37Siu4DYrdef/Szesei5
        tmYRacdiXyKkyYnsYqsWiDJQY85B1Wersg4jLE/AKN3ngkm7SIkk5UsbUtrqtnjzdCChuZBJXedpK
        gYCz6TfQ==;
Received: from pool-108-4-135-94.albyny.fios.verizon.net ([108.4.135.94]:53094 helo=smtpclient.apple)
        by premium237.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <srw@sladewatkins.net>)
        id 1oeEct-003E7x-Jh;
        Fri, 30 Sep 2022 07:56:19 -0400
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
From:   Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <YzbRcyi6Evu2RrNt@kroah.com>
Date:   Fri, 30 Sep 2022 07:56:17 -0400
Cc:     Jerry Ling <jiling@cern.ch>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <AC85817F-029E-4CDD-BFB8-9A9751D52532@sladewatkins.net>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com> <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
 <YzbRcyi6Evu2RrNt@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - premium237.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sladewatkins.net
X-Get-Message-Sender-Via: premium237.web-hosting.com: authenticated_id: srw@sladewatkins.net
X-Authenticated-Sender: premium237.web-hosting.com: srw@sladewatkins.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

> On Sep 30, 2022, at 7:22 AM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> On Fri, Sep 30, 2022 at 07:11:19AM -0400, Slade Watkins wrote:
>> Hey Greg,
>>=20
>>> On Sep 30, 2022, at 1:59 AM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
>>>=20
>>> On Fri, Sep 30, 2022 at 06:37:48AM +0200, Greg KH wrote:
>>>> On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
>>>>> Hi,
>>>>>=20
>>>>> It has been reported by multiple users across a handful of distros =
that
>>>>> there seems to be regression on Framework laptop (which presumably =
is not
>>>>> that special in terms of mobo and display)
>>>>>=20
>>>>> Ref: =
https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-ar=
ch1-1-on-arch-linux-gen-11-model/23171
>>>>=20
>>>> Can anyone do a 'git bisect' to find the offending commit?
>>>=20
>>> Also, this works for me on a gen 12 framework laptop:
>>> 	$ uname -a
>>> 	Linux frame 5.19.12 #68 SMP PREEMPT_DYNAMIC Fri Sep 30 07:02:33 =
CEST 2022 x86_64 GNU/Linux
>>>=20
>>> so there's something odd with the older hardware?
>>>=20
>>> greg k-h
>>=20
>> Could be. Running git bisect for 5.19.11 and 5.19.12 (as suggested by =
the linked forum thread) returned nothing on gen 11 for me.
>>=20
>> This is very odd,
>=20
> So 5.19.11 works for you, but 5.19.12 does not?
>=20
> Or is it just the arch packaged kernel that does not work for you?
>=20

Oh, no no no. I was saying there weren't any issues. I myself haven=E2=80=99=
t had any issues on gen 11 framework.

I tested the arch-packaged versions, as well as the kernels directly =
from source. Both didn=E2=80=99t have anything to report from bisect. =
(Odd? Yeah.)

I=E2=80=99m really sorry for the confusion,
-srw

