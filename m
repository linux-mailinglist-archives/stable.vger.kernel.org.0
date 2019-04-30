Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E373FFE4
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 20:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfD3Soi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 14:44:38 -0400
Received: from mout.gmx.net ([212.227.17.22]:37641 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfD3Soi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 14:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556649869;
        bh=nFywZfPFFxBbp1tsvXp26L1k4O4as3PDpwSmfbc/kPY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=dSayyNCHCwVc4offR3iwSFSYmjz1yNXLWcJl7e7wAZAUBCDjxPtMgTUt8gAxG4Blm
         yigAlrJOesuytPeaWZrSS7hMD3KM2x6L0tG4bWvPzS8xfa2HmSeMhOrYOKOMTDZTIZ
         4czkeujn937oT4xDsWxb7UxK4ZBzJBXfJZJFhwqg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.203.76.133]) by mail.gmx.com
 (mrgmx101 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0MfzEP-1h9lWK2KXN-00NTOL; Tue, 30 Apr 2019 20:44:29 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 742EF800A5; Tue, 30 Apr 2019 20:44:28 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Major Hayden <major@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?Q?=E2=9D=8E?= FAIL: Stable queue: queue-5.0
References: <cki.6C208109D9.WGQF5P41NS@redhat.com>
        <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
        <20190430130331.GA6937@sasha-vm> <20190430132700.GA12407@kroah.com>
        <20190430134159.GB6937@sasha-vm> <20190430140125.GA18765@kroah.com>
        <641778a3-be33-d07a-1120-4a49a5010c89@redhat.com>
        <20190430155827.GC6937@sasha-vm>
Date:   Tue, 30 Apr 2019 20:44:28 +0200
In-Reply-To: <20190430155827.GC6937@sasha-vm> (Sasha Levin's message of "Tue,
        30 Apr 2019 11:58:27 -0400")
Message-ID: <87pnp3fi43.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Dcv4BnpDQ4GosIlDUFq2upwccB9ia5qAqqzURU1e0JhdPLoLYNF
 deDYhlNlBksBWW9DJn3Y4ReUhMmkyRZjcxWWjdymNI8+ORqykFhYwIIAE2lGapij27NT5Sp
 XUJN2mA3LPDjyORc52Zch0rTznftDQ+k4N92zddQ4GtFm1er5RqEt5xR6YViP+Ka8/RBkFM
 BKKKdC6Sau1y3SA+ksA+Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LMZC8lMa3iE=:YGksMjF7KfZ+2rtGjmoT8U
 VbywT57G1fmw8zmX1jbkJLiOZme1kukreOv2p1pc/7vzgms5r+5qdAiOMOAlJ2+PPcLlQdciX
 TjFdrOLsXW39GVOoOiqkuV76LjOJcyssr/D44FZbfe8FyMo58PvzuG9Qoi7CSlqOO8dR36eMA
 840dcO/npimtlS4RNma2u4ma+xA/MsYjEgWZ/yqifgkVnSg7Sr3NiWQ+GExE4Rt0biRqR4mHg
 I3xSSAEUrBvDirkrTuR7Pu2tpL4m/bq/Qc42n+sUPZqNI6A7bW8ZYZe7C5tvZWwf2O9OdsJ4E
 qiw7MBA5lPIix7PtxvTY+GVAyhLbVEPpOhw5OB2MBM1VVyU2UxmZrZKCW5Nu3atE7OhaTt4lP
 VLEuJq3R5MzEzkZRjCNXal94zdnJzr2JesmHv3mvBhNDIsun1xMc5jdHGmyN3/h4gEOLQ1oay
 y0K70uCKKAMz3adYOSfrOfKqc3cBKzQ7h0opsWaooZaGl3Y9P/4AwA/hg2qWWuqPhyJkChz0J
 NgKC0n54FjEjD+oUd7Eej4uRIr8goad1btcbdL8r3Sn/iDs91HM4JwNEsizQkXuhJrPWbKwcN
 hHswibDHwYCK69i8LNTsEVKVmIgHsJSWPwQ6pis3oQ4D8SotcBkK92cODMLD+C9O+96azbgvp
 3Sm+p0YWgVPUtH6exZPWuIDTO1SdCqTPO5pFrgJK3Rdthumb3Z3qFgwo9AE81og9olh+udKq7
 VoE4Xr+8QIOeaaC9Ec9ydyicB90rDSGSjo79JLuBxQIbUZIWouPrGyOAV13sYAUZPqRHcubjw
 cT6Ybws2Jobl3U8OQuFKBqMTpku864DcyOKvX/YzJY/hEnbvUjD6YVkuOXbIrDl8BEK/VQ1Xa
 DJ2dD/buRmDKKJAg/GIQtnmh26BRvRjpScWiDeuuvhd+NLYfuSVd1PuMUzD/NZHPi7AX3CUkl
 xAy8zaJ+p5Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-04-30 11:58 -0400, Sasha Levin wrote:

> On Tue, Apr 30, 2019 at 10:17:17AM -0500, Major Hayden wrote:
>>On 4/30/19 9:01 AM, Greg KH wrote:
>>> On Tue, Apr 30, 2019 at 09:41:59AM -0400, Sasha Levin wrote:
>>>> On Tue, Apr 30, 2019 at 03:27:00PM +0200, Greg KH wrote:
>>>>> On Tue, Apr 30, 2019 at 09:03:31AM -0400, Sasha Levin wrote:
>>>>>> Hello CKI folks,
>>>>>>
>>>>>> A minor nit: the icon added before the subject text gets filtered ou=
t on
>>>>>> the textual email clients most of us use, and ends up appearing (at
>>>>>> least for me) as 3 spaces that cause much annoyance since it gets
>>>>>> confused with mail threading.

If you see 3 spaces rather than just one, you probably use a single-byte
locale (e.g. 'C'), rather than a UTF-8 one.

>>>>> Really?  It's just a "normal" emoji character, perhaps you need a bet=
ter
>>>>> email client or terminal window?  :)
>>>>>
>>>>> What are you using that you can't see this in a terminal?
>>>> Um, mutt on xterm...
>>> Use a "modern" terminal program please, that's the problem here.  I just
>>> tried 4 different ones (gnome-terminal, terminology, tilix, and kitty),
>>> and they all worked just fine.
>>>
>>> With mutt :)
>>
>>We can change the email format very easily. If removing the emoji in
>> the subject line would be better, that's a really quick change for
>> us.
>>
>>Our hope was that it would make it easier to identify automated CI
>> results and make it easier to know the feedback when you're looking
>> at a lot of email threads.
>
> I thought this was an issue for more people than just me. I'll just use
> a newer terminal emulator :)

Or configure xterm correctly.  The '=E2=9D=8E'emoji displays just fine under
"LC_ALL=3Den_US.UTF-8 xterm -fa DejaVuSansMono" (tested with xterm 344).

Cheers,
       Sven
