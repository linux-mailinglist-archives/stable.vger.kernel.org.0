Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134BF293FDF
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgJTPrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 11:47:53 -0400
Received: from sonic310-14.consmr.mail.bf2.yahoo.com ([74.6.135.124]:46824
        "EHLO sonic310-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728129AbgJTPrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 11:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603208872; bh=gdAB6QqlMM69Y3Y3c0Hky/p8FtwBmV0ljKTempD8n0s=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hql72l8iZHid+efKvsCm+DZY337xIxj4JIUFbVLGKMoXmR8R8AHVvTJ9O7KH5o6r/QbiR7qrflo4Dq4auBbbKDYVRbCCxMCSCRlOl+v1qJWL6UU9Zfo99YpiYlWvYNjBGDHKdR8Pm/mxbTcfASCRTPDBtr+iwuarKsK+Dce8abA57pm2lqi6U3USssvW6QMUnHDVfZF1ARsXIhDE3VTs7Cb2y+tPI1z6a7nogaRLHYCFNCCHQ7G7Tayf3sangJMzQr4MCn4kfmlo0qCWienUGPNnNkBYY1a7qxN7N0qBfo/OoMlDSHB7QcxH0ueuPJdCxHaINzZkkFu8gdOamQ7hEQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603208872; bh=b5v+PvxFIOREMH0Ub7/4AqtARtMvkPspWbgJ92jwZB6=; h=Date:From:Subject; b=E32nv7wKnNIe+peX7oY6J4+9RnArf1zMc4xP54XaUSt5spKOW9vZ+098a+Cnv+4UnI8pnPkbwRl/JGYesZjn8K5fXAax0tgrroj8DwF87ctV0undoCesYjcpEcBw8eA6pTT0xLzd6rHR0C3IOWr5bKjxyRQATUNf4zSWYIWzdWgbwRbcUovozCgcUNPiXKN5M1fMAi7GmHVeOGR5vjqTSlRtgzdLUiHG3jh6be0KeAB60RgrOLDw7ikUZiTipAtBK+Kaz2TYo5L5J+vaAS5VoiKy9JAHI3re6x+T57oXDVNIrHh8mvi5y7MHZ7ZKML7milBxxwBg80NCxbwETEjKIQ==
X-YMail-OSG: 7ActdQYVM1ljC3NvMsARu2vqAUqL0TPPrhSD_sb8UmoIYvDzKujg95IDF0Z2cdJ
 TD35pUDQxWm1Yg92mxCxCQ0vPN8HL2IYU0zxqYl0y3wFkQpNjpd10DoGSnY3pjxpv7D0lF762HSz
 4q_DpdQWqRbD4HHUKWp06HVgjk.2O9jh7mIbCBzLwJ9M8LS5x5RErXbfSgyg7n6ZCYsdWY.KcXiu
 7TC_VP1lpQwGsTGQUzXoZZ69kAnSfDpLnpZLQemq9eFB7T0va7xSteFwbnpfcOwCOC2JMGJ_R2l0
 _tUWafDzF2Bq5rpllr9B3apv1YfrBnupOZPEK8saYdS5FuG_y6gugtnBPvtvjOTD0M88Di.LlsiF
 huYPBX2lGa_txeIQi6iZ55mTBgg4YJhv3M7oV0csZP9eHKy4bV5m6tQRZQy.zNES3iurPWtlVSbg
 D8WrrNvt3j9y9waqhnv1aWC0CayS5SxV7j9dYjDglxLR.wRlIDD6mM9zsKymxvSnmUMSLs8LLVVq
 Swn9Mt3HrQ50frr0X0KygZCGh35kx4jWPP_iKnBCZeaVSttzjFtj5vziHBdWfdDbDDtPDcH8zGBT
 WFvXQXXRJFdZnuCYgXimGZ.Z_W4p6A5_1uCSh9_AhXA54WtiTyRW9FQvzvl72JvAylwe8byCpVMW
 9EZIP_JyLYBTIcfH7UHOY3Jm_lCWZ_cn39q6kdIQXDtHAs3GtVlOLVchxSsQA0rZdn_poKvmsQCt
 Ga1G3Yuhsm7Y4Tw8C_n3dgKr9g.4Gxnrx6bDG6tvUl7GkJtstRkO2cZUbfZWg.OY7FAbSR_C_j0M
 qN6MPbBqyEEjHWziTe6CoqcuI.OgLnjBvCpBxhw5BIraj4wfUi6xT6ugTo9wvk3SP.3hiCtdRk6E
 .8KInSCstXlMuc0MYHxYewXhQX12kPZMozd7kS0vDs11YdFHtoOUqwCsEpL4FDOGId.VNZKlxeLw
 bWBu7x48FDbm89bQic9LG0fA6otDQ2_jGAD_Obsx_yJbm4srcKEMayQlvggRfHPQOc._9r06HWQy
 jSLOY5thXgVxwzq.RpXKlnX_WUWJAkqBrMmHrVats3EgnFUroYGDncWuvyRrMys5ncL1piSa8jtL
 S9.moolcDwTR2ZoijB0jvJnlGRB6LlkFagqmosppyyCNmapxqM.1Kc6oabaU42RfBP0jksgueTdx
 8fvmlE3K05Ayv.4F5FdQvq54GxNfcxpYCx94ETycsYzYM1DN2.LskAD_qg8MpTc5grFh4A1cUtPx
 SMZ2JanIWg9cFE9uKERnuo8XJSXhQu9Ao_bPNTAbXgu.4Mtgkd4ytFh7VFFDrzylBvrb2zoPmVMn
 kQnxIPazKBO3qYksL9gquXk28Htr.Yg1gK8qccxKYukwLo4FYLYncCkwLwYFn0m9d27fOwT1XuIu
 gpmxQgC0XZSt7ptGtREjbg1bOrGGLikElglncXUkArw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Tue, 20 Oct 2020 15:47:52 +0000
Date:   Tue, 20 Oct 2020 15:47:46 +0000 (UTC)
From:   "Mr. Mohammed Emdad " <gerasimmelkumyan853@gmail.com>
Reply-To: mohammedemdadmohammedemdad77@gmail.com
Message-ID: <1235322360.1084613.1603208866679@mail.yahoo.com>
Subject: URGENT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1235322360.1084613.1603208866679.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,


My name is Mr.Mohammed Emdad, I am working with one of the prime bank in Bu=
rkina Faso. Here in this bank there is existed dormant account for many yea=
rs, which belong to one of our late foreign customer. The amount in this ac=
count stands at $13,500,000.00 (Thirteen Million FiveHundred Thousand USA D=
ollars).

I need a foreign account where the bank will transfer this fund. I know you=
 would be surprised to read this message, especially from someone relativel=
y unknown to you But do not worry yourself so much.This is a genuine, risk =
free and legal business transaction. I am aware of the unsafe nature of the=
 internet, and was compelled to use this medium due to the nature of this p=
roject.

There is no risk involved; the transaction will be executed under a legitim=
ate arrangement that will protect you from any breach of  law.  It is bette=
r that we claim the money, than allowing the bank directors to take it, the=
y are rich already. I am not a greedy person, Let me know  your mind on thi=
s and please do treat this information highly confidential. I will review  =
further  information=E2=80=99s / details to you as soon as i receive your p=
ositive reply.

If you are really sure of your integrity, trust worthy and confidentiality,=
  kindly get back to me urgently.

Note you might receive this message in your inbox or spam or junk folder, d=
epends on your web host or server network.

Best regards,

I wait  for your positive response.

Mr. Mohammed Emdad
