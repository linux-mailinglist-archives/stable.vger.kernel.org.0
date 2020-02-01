Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C0914FA13
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 20:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgBATBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 14:01:46 -0500
Received: from sonic316-53.consmr.mail.ne1.yahoo.com ([66.163.187.179]:39189
        "EHLO sonic316-53.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgBATBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 14:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580583704; bh=3gwbdpD6fpTnU3AIhQs1dw9/oeXqxu71NA+1nQpVq+I=; h=Date:From:Reply-To:Subject:References:From:Subject; b=n0kiaYRib828FF+QxlLALkHV0GFsW9rlH6UkZhgzhz3eT594lb5lwu51mh5jTKXzYGkGGKXkluybVYqpMby59haRWDFygvjQA/IQtLKyNAKThpz+mAjUVxQttZKKKP5NvXFLVSkQMYCLd4CcEvjE0FC3YILWTzQi/xToYithDtMu97e+hTY+ZHQnJpL4Ue7fGFRf9AOXiShn3+UfMxV9ak+uQjFzHo5utKawo6917ArF2m587R2B28oPX8zlwIKxt9METXtU+T6DGD5dIQFGt3QIgS90b2eFqcDXEzHt0Dmof4AdjBEFM9zU9ZbrzxjUd3oyJbaadX9HuIhEcpRE/w==
X-YMail-OSG: FcqDiqwVM1n0HUFHjYGnRxTER22gHWDWC5oNTCokj9TEVBYuElCGmwP15LQAcIa
 Dt1QHkjoiVxaNpd9FTqVkLj.h9oPbdj1k34ag4i8jaTyvn0.myyxoFgfr4xNVmYO24kfYwsIy2WO
 CvzbCmNFPPBdyIVdN3CryoqsdyYzwk5fZUth2InN9D39WsgbqAIP_HgFnw1rqHuvzMmxUkYae25v
 CWLDeIoJnqMiFVYL.nl0KHd1Xoi.fUE1pRN6HW.2hV93wTa.EDAJMIDbMQDYj4XulkD5bIXnnknA
 9z80TZmOtWV3SShDqFRRbxsnjonQUwjQAW5EJe9lhyEMs6B_je9vRTCvq9a_grtLFWI3TJWE_HMN
 MCaloVSmZ2p3nec5u4LYkBRSMzxGGIP_Kayf6JVMJtBeGDFHxUd7V3vsiBznj25FIMX.D8Nz_6z7
 Yf66mw0WuA6JAr8HcsjqgzLmVRFj7l_eWdAIYyJ9fiQdj3uBLt8EuSMC76g929SJFRnS3HOxbbID
 itcqsqCAviuHKbNyS0TXUdbjRmPiIZWHG1Eku8TkZUHOfboqKvvqozQq4q1anbU0fqU0D8UNp9JP
 a9WNRkHXmbIJENAAVd.8JHfCnNMAcZEXAta8FyLtJXCwK8CLzQZ5SFKGiVTgJlx.STqzyO7WWOcw
 dH34mGzJN6EuavQF3BFEfOE7Z5g3.XQdvoGYFDrFPxscIP.mqhdk2uQRE_ezpxn36hCT1XPf0WGz
 1X.u8qTh7wpIYdUTh4hgW7OlPS0_owB91rPNlv5rWX_V1unDlTov2ro8oNn4IwFIQhrSjTdcPNOT
 wIVrvDmXQqfPtcv8XIBzAYV4rjOBTZNBK9DU2pm0N4YjgWqkHeaDiY58oCVid3TuQLvEGvdtYWyP
 WaEmB_fL9ZJpCqQytEtY43r9o_tvOjotS8T50EkcLBy.0JjuZfhJ7YmFr.agPCNQRu5u7AuY1eIf
 uvq0hZcFwVc9RAA8SXEOT55Q2vwt_dKBBKAFneJ7kCx98sbWAlzmLntbLKP6rtBgFx_C0Y0WIQ.p
 xNsWexA0BeBAFU_tboT6niWIwAKV3aEP8VFUEnWXnByPODQ44LrZXc045T0FuIH4xjPR0CjSAvJk
 odo9v02G_4dfZDI98vup1l__n7.2p3_fLHgAOe12LYS8Arg8UGpeDaf2YcUu6dBfLuspKnf0pFxr
 XgDCkNzLfsluXBCMPgPjCyTqqy4kUQRHRCGZpL_vdUPJOQxbSLssxeJxOeSlU46r4kRFvDcH8Aby
 2gJT0iSoXC91RduZPJ6sBTfSw3oVogWEGtpCs5_pLbYPTybfvLxEuUgG4ObxvAhtWfCq8ewZsWF2
 isgu.MB3_rVAhlSSqqG7MwfQKj_4uyPVeRiH_
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Sat, 1 Feb 2020 19:01:44 +0000
Date:   Sat, 1 Feb 2020 18:59:43 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <zz54@gczao.com>
Reply-To: maurhinck7@gmail.com
Message-ID: <780390527.305603.1580583583841@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <780390527.305603.1580583583841.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15149 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36 OPR/66.0.3515.44
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck7@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
